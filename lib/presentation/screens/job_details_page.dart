import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';
import 'package:pacific_kode_practical/presentation/provider/job_provider.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Apply button pressed!')),
                  );
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
}
