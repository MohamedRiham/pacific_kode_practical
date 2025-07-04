class Job {
  final String? id;
  final String? title;
  final String? company;
  final String? location;
final String? salary;
final String? jobType;
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
