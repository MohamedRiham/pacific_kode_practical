import 'package:pacific_kode_practical/presentation/screens/job_list_page.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';
import 'package:pacific_kode_practical/presentation/screens/favourite_jobs_page.dart';
import 'package:provider/provider.dart';

class AppliedJobsPage extends StatefulWidget {
  const AppliedJobsPage({super.key});

  @override
  State<AppliedJobsPage> createState() => _AppliedJobsPageState();
}

class _AppliedJobsPageState extends State<AppliedJobsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        Provider.of<JobProvider>(
          context,
          listen: false,
        ).getAppliedJobsFromDatabase();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to load jobs')));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'My Jobs',
      body: SafeArea(
        child: Consumer<JobProvider>(
          builder: (context, jobProvider, _) {
            return jobProvider.myJobList.isEmpty
                ? Center(child: Text('No applications yet.'))
                : ListView.builder(
                    itemCount: jobProvider.myJobList.length,
                    itemBuilder: (context, index) {
                      final candidate = jobProvider.myJobList[index];
                      final Job job = jobProvider.jobList.firstWhere(
                        (j) => j.id == candidate.jobId,
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.business, size: 16),
                                  const SizedBox(width: 6),
                                  Text(job.company ?? 'Unknown Company'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16),
                                  const SizedBox(width: 6),
                                  Text(job.location ?? 'Unknown Location'),
                                ],
                              ),
                              const Divider(height: 20),
                              Text(
                                'Candidate Info',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text('Name: ${candidate.candidateName}'),
                              Text('Email: ${candidate.candidateEmail}'),
                              Text('Phone: ${candidate.candidatePhone}'),
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
