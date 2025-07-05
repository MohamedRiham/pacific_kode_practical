import 'package:hive_local_storage/hive_local_storage.dart';

part 'candidate.g.dart';

@HiveType(typeId: 2, adapterName: 'CandidateAdapter')
class Candidate {
  @HiveField(0)
  final String jobId;

  @HiveField(1)
  final String candidateName;

  @HiveField(2)
  final String candidateEmail;

  @HiveField(3)
  final String candidatePhone;

  Candidate({
    required this.jobId,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidatePhone,
  });
}