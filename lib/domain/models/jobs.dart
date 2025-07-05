import 'package:hive_local_storage/hive_local_storage.dart';

part 'jobs.g.dart';

@HiveType(typeId: 1, adapterName: 'JobAdapter')
class Job extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? company;
  @HiveField(3)
  final String? location;
  @HiveField(4)
  final String? salary;
  @HiveField(5)
  final String? jobType;
  @HiveField(6)
  final String? description;

  Job({
    this.id,
    this.title,
    this.company,
    this.location,
    this.salary,
    this.jobType,
    this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      jobType: json['job_type'],
      description: json['description'],
    );
  }
}
