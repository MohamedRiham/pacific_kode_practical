import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/data/api_service/api_constants.dart';
import 'package:pacific_kode_practical/data/api_service/api_service.dart';
import 'package:pacific_kode_practical/domain/models/jobs.dart';

class JobProvider with ChangeNotifier {
  List<Job> jobList = [];
  List<Job> filteredJobList = [];
  final ApiService apiService = ApiService();

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
}
