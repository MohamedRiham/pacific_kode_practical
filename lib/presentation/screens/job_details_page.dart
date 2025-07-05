import 'package:flutter/services.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/widgets/custom_text_field.dart';
import 'package:pacific_kode_practical/domain/models/candidate.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';
import 'package:provider/provider.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final jobProvider = Provider.of<JobProvider>(context);
    return CustomScaffold(
      title: 'Job Details',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title ?? '',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.business,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(job.company ?? 'Unknown Company'),
                const SizedBox(width: 20),
                Icon(
                  Icons.location_on,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(job.location ?? 'Unknown Location'),
              ],
            ),

            const SizedBox(height: 16),

            if (job.description != null && job.description!.isNotEmpty) ...[
              Text(
                'Job Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job.description!),
              const SizedBox(height: 20),
            ],

            if (job.jobType != null) ...[
              Text(
                'Job Type: ${job.jobType}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],

            if (job.salary != null) ...[
              Text(
                'Salary: ${job.salary}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ],

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  showApplyDialog(context, jobProvider);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showApplyDialog(BuildContext context, JobProvider jobProvider) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Apply for Job'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  hintText: 'Enter your name',
                  icon: Icons.person,
                ),

                CustomTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  icon: Icons.email,
                ),
                CustomTextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: 'Enter your phone number',
                  icon: Icons.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Candidate candidate = Candidate(
                    jobId: job.id ?? '0',
                    candidateName: nameController.text.trim(),
                    candidateEmail: emailController.text,
                    candidatePhone: phoneController.text,
                  );
                  bool isExists = await jobProvider.saveJobApplication(
                    candidate,
                  );
                  if (context.mounted) {
                    if (isExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You have already applied to this position',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Application submitted!')),
                      );
                    }
                    Navigator.pop(context);

                  }
                }
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
