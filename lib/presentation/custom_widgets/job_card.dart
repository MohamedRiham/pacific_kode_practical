import 'package:pacific_kode_practical/domain/models/jobs.dart';

import 'package:flutter/material.dart';

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
                  Semantics(
                    label: 'Add to favourites',
                    excludeSemantics: true,
                    container: true,
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: onFavourite,
                    ),
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
              Center(
                child: Text(
                  (job.description?.length ?? 0) > 20
                      ? '${job.description!.substring(0, 20)}...'
                      : job.description ?? '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
