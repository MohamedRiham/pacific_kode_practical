import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/services/dialog_service.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';
import 'package:provider/provider.dart';

class FavouriteJobsPage extends StatefulWidget {
  const FavouriteJobsPage({super.key});

  @override
  State<FavouriteJobsPage> createState() => _FavouriteJobsPageState();
}

class _FavouriteJobsPageState extends State<FavouriteJobsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        Provider.of<JobProvider>(context, listen: false).getJobFromDatabase();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load jobs from database')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      needSideDraw: true,
      title: 'Favourite Jobs',


      body: SafeArea(
        child: Consumer<JobProvider>(
          builder: (context, jobProvider, _) {
            return jobProvider.favouriteJobList.isEmpty
                ? const Center(child: Text('No favourite jobs yet.'))
                : ListView.builder(
                    itemCount: jobProvider.favouriteJobList.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final job = jobProvider.favouriteJobList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Company: ${job.company ?? 'N/A'}'),
                              Text('Location: ${job.location ?? 'N/A'}'),
                              Text('Job Type: ${job.jobType ?? 'N/A'}'),
                              if (job.salary != null)
                                Text('Salary: ${job.salary}'),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Job Description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(job.description ?? ''),

                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,

                                child: Semantics(
                                  label: 'Delete',
                                  button: true,
                                  container: true,
                                  excludeSemantics: true,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await showMessageDialog(
                                        message:
                                            'Are you sure you want to delete this item?',
                                        titleText: 'Warning',
                                        yesFunction: () {
                                          try {
                                            jobProvider.deleteDataFromDatabase(
                                              job,
                                            );
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'An error occurred while deleting data',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
