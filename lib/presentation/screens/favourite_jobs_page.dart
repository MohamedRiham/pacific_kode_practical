import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';
import 'package:pacific_kode_practical/presentation/screens/job_list_page.dart';
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
      Provider.of<JobProvider>(context, listen: false).getJobFromDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Favourite Jobs',
      body: Consumer<JobProvider>(
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
                              job.title ?? 'No Title',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Company: ${job.company ?? 'N/A'}'),
                            Text('Location: ${job.location ?? 'N/A'}'),
                            Text('Job Type: ${job.jobType ?? 'N/A'}'),
                            if (job.salary != null)
                              Text('Salary: ${job.salary}'),
                            const SizedBox(height: 8),
                            Text(job.description ?? ''),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  jobProvider.deleteDataFromDatabase(job);
                                },
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
      botumNavigation: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => JobListPage()),
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
