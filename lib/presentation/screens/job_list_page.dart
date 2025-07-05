import 'package:pacific_kode_practical/core/widgets/search_bar.dart';
import 'package:pacific_kode_practical/presentation/screens/favourite_jobs_page.dart';
import 'package:pacific_kode_practical/presentation/screens/job_details_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  bool _isLoading = false;
  late JobProvider jobProvider;

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
      title: 'Job Listings',
      body: Column(
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

          Expanded(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JobDetailsPage(job: job),
                                ),
                              );
                            },
                            onFavourite: () async {
                              bool alreadySaved = await jobProvider
                                  .saveJobToDatabase(job);
                              if (context.mounted) {
                                if (alreadySaved) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Job is already in favourites',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Job added to favourite list',
                                      ),
                                      backgroundColor: Colors.white,
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
        ],
      ),
      botumNavigation: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FavouriteJobsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Jobs'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite Jobs',
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback navigation;
  final VoidCallback onFavourite;
  const JobCard({
    super.key,
    required this.job,
    required this.navigation,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigation,

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.title ?? '__',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: onFavourite,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16),
                      const SizedBox(width: 2),
                      const Text('Company'),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(job.company ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 2),

                      const Text('Location'),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(job.location ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(width: 2),

                      const Text('Job Type'),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Text(job.jobType ?? 'N/A'),
                ],
              ),
              const Divider(thickness: 5.0),
              Center(child: Text(job.description ?? '')),
            ],
          ),
        ),
      ),
    );
  }
}
