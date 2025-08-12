import 'package:pacific_kode_practical/domain/models/jobs.dart';

abstract class JobFilter {
  List<Job> filter(List<Job> jobs);
}

class SalaryFilter extends JobFilter {
  final int salary;

  SalaryFilter({required this.salary});

  @override
  List<Job> filter(List<Job> jobs) {
    return jobs
        .where(
          (job) => job.numericSalary != null && job.numericSalary! == salary,
        )
        .toList();
  }
}

class LocationFilter extends JobFilter {
  final String location;

  LocationFilter(this.location);

  @override
  List<Job> filter(List<Job> jobs) {
    return jobs
        .where((job) => job.location?.toLowerCase() == location)
        .toList();
  }
}

class JobTypeFilter extends JobFilter {
  final String jobType;

  JobTypeFilter(this.jobType);

  @override
  List<Job> filter(List<Job> jobs) {
    return jobs.where((job) => job.jobType?.toLowerCase() == jobType).toList();
  }
}
