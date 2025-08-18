import 'package:pacific_kode_practical/core/widgets/custom_dropdown.dart';
import 'package:pacific_kode_practical/core/widgets/custom_text_field.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';
import 'package:pacific_kode_practical/presentation/custom_widgets/job_card.dart';
import 'package:pacific_kode_practical/core/services/navigation.dart';
import 'package:pacific_kode_practical/core/widgets/search_bar.dart';
import 'package:pacific_kode_practical/presentation/screens/job_details_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  bool _isLoading = false;
  late JobProvider jobProvider;
  String? selectedJobType;
  String? selectedSalary;
  String? selectedLocation;
  Future<void> loadJobs() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await jobProvider.getJobList();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load jobs'),
            action: SnackBarAction(label: 'Retry', onPressed: loadJobs),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    jobProvider = Provider.of<JobProvider>(context);
    return CustomScaffold(
      needSideDraw: true,
      title: 'Job Listings',
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchBox(
                hiddenText: 'Search',
                search: (text) {
                  jobProvider.searchJobs(text);
                },
                onChange: (text) {
                  if (text.isEmpty) {
                    jobProvider.searchJobs(text);
                  }
                },
              ),
              SizedBox(height: 10.0),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDropdown(
                    hintLabel: 'Salary',
                    value: selectedSalary,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSalary = newValue;

                        jobProvider.sortSalary(newValue!);
                      });
                    },
                    items: ['All', '30000', '80000'],
                  ),
                  SizedBox(width: 5.0),

                  CustomDropdown(
                    hintLabel: 'Job Type',
                    value: selectedJobType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedJobType = newValue;
                        jobProvider.sortJobType(newValue!);
                      });
                    },
                    items: ['All', 'Intern', 'Associate', 'Senior'],
                  ),

                  SizedBox(width: 5.0),

                  CustomDropdown(
                    hintLabel: 'Location',
                    value: selectedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        selectedLocation = newValue;
                        jobProvider.sortLocation(newValue!);
                      });
                    },
                    items: ['All', 'Colombo', 'Jaffna', 'Athurugiriya'],
                  ),
                ],
              ),

              SizedBox(
                height: 400,
                child: Consumer<JobProvider>(
                  builder: (context, jobProvider, _) {
                    return _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : jobProvider.filteredJobList.isEmpty
                        ? Center(child: Text('No Jobs Available'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: jobProvider.filteredJobList.length,
                            itemBuilder: (context, index) {
                              final job = jobProvider.filteredJobList[index];
                              return JobCard(
                                job: job,
                                navigation: () {
                                  Navigator.of(context).push(
                                    createSlideRoute(
                                      page: JobDetailsPage(job: job),
                                      beginOffset: const Offset(1.0, 0.0),
                                    ),
                                  );
                                },
                                onFavourite: () async {
                                  try {
                                    bool alreadySaved = await jobProvider
                                        .saveJobToDatabase(job);
                                    if (context.mounted) {
                                      if (alreadySaved) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Job is already in favourites',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Job added to favourite list',
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'An error occurred while saving',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Semantics(
                  label: 'Add Job',
                  button: true,
                  excludeSemantics: true,

                  child: IconButton(
                    onPressed: () {
                      _showAddJobDialog();
                    },

                    icon: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddJobDialog() {
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();
    final salaryController = TextEditingController();
    final jobTypeController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Job"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: titleController,
                      hintText: 'Title',
                      icon: Icons.title,
                      keyboardType: TextInputType.text,
                    ),
                    CustomTextField(
                      controller: companyController,
                      hintText: 'Company',
                      icon: Icons.place,
                      keyboardType: TextInputType.text,
                    ),
                    CustomTextField(
                      controller: locationController,
                      hintText: 'Location',
                      icon: Icons.location_on,
                      keyboardType: TextInputType.text,
                    ),
                    CustomTextField(
                      controller: salaryController,
                      hintText: 'Salary',
                      icon: Icons.money,
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextField(
                      controller: jobTypeController,
                      hintText: 'Job Type',
                      icon: Icons.work,
                      keyboardType: TextInputType.text,
                    ),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      icon: Icons.description,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    AddJob addJob = AddJob(
                      title: titleController.text,
                      company: companyController.text,
                      location: locationController.text,
                      salary: salaryController.text,
                      jobType: jobTypeController.text,
                      description: descriptionController.text,
                    );
                    await jobProvider.addJob(addJob);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'QAn error occurred while saving details',
                          ),
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
