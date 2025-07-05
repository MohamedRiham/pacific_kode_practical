import 'package:flutter/material.dart';
import 'package:hive_local_storage/hive_local_storage.dart';
import 'package:pacific_kode_practical/data/api_service/api_constants.dart';
import 'package:pacific_kode_practical/data/api_service/api_service.dart';
import 'package:pacific_kode_practical/domain/models/candidate.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';

class JobProvider with ChangeNotifier {
  List<Job> jobList = [];
  List<Job> filteredJobList = [];
  final ApiService apiService = ApiService();
  late final LocalStorage database;
  List<Job> favouriteJobList = [];
  Future<void> initDatabase() async {
    database = await LocalStorage.getInstance();
    Hive.registerAdapter(JobAdapter());
    Hive.registerAdapter(CandidateAdapter());
    await database.openBox<Job>(boxName: 'job_box', typeId: 1);
    await database.openBox<Candidate>(boxName: 'candidate_box', typeId: 2);
  }

  Future<bool> saveJobToDatabase(Job job) async {
    final existingJobs = database.values<Job>('job_box');
    final isAlreadySaved = existingJobs.any((j) => j.id == job.id);
    if (!isAlreadySaved) {
      await database.add(boxName: 'job_box', value: job);
    }
    return isAlreadySaved;
  }

  void getJobFromDatabase() {
    favouriteJobList = database.values<Job>('job_box');

    notifyListeners();
  }

  void deleteDataFromDatabase(Job job) async {
    await database.delete<Job>(boxName: 'job_box', value: job);
    favouriteJobList.removeWhere((element) => element.id == job.id);
    notifyListeners();
  }

  //this method fetches all the jobs from the api
  Future<void> getJobList() async {
    try {
      var response = await apiService.getRequest(
        url: '${ApiConstants.baseUrl}/jobs',
      );
      jobList = response.map<Job>((json) => Job.fromJson(json)).toList();
      filteredJobList = jobList;
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
    notifyListeners();
  }

  void searchJobs(String query) {
    if (query.isEmpty) {
      filteredJobList = jobList;
    } else {
      filteredJobList = jobList.where((job) {
        return (job.title != null &&
                job.title!.toLowerCase().contains(query.toLowerCase())) ||
            (job.company != null &&
                job.company!.toLowerCase().contains(query.toLowerCase())) ||
            (job.location != null &&
                job.location!.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }

    notifyListeners();
  }

  //saving candidate details
  Future<bool> saveJobApplication(Candidate candidate) async {
    final availableJobApplications = database.values<Candidate>(
      'candidate_box',
    );
    final isAlreadySaved = availableJobApplications.any(
      (can) => can.jobId == candidate.jobId,
    );
    if (!isAlreadySaved) {
      await database.add(boxName: 'candidate_box', value: candidate);
      notifyListeners();
    }
    return isAlreadySaved;
  }
}
