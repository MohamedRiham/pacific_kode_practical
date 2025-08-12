import 'package:pacific_kode_practical/domain/models/job_filter.dart';
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
  List<Candidate> myJobList = [];

  String selectedSalary = 'All';
  String selectedJobType = 'All';
  String selectedLocation = 'All';

  Future<void> initDatabase() async {
    try {
      database = await LocalStorage.getInstance();
      Hive.registerAdapter(JobAdapter());
      Hive.registerAdapter(CandidateAdapter());
      await database.openBox<Job>(boxName: 'job_box', typeId: 1);
      await database.openBox<Candidate>(boxName: 'candidate_box', typeId: 2);
    } catch (e) {
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<bool> saveJobToDatabase(Job job) async {
    try {
      final existingJobs = database.values<Job>('job_box');
      final isAlreadySaved = existingJobs.any((j) => j.id == job.id);
      if (!isAlreadySaved) {
        await database.add(boxName: 'job_box', value: job);
      }
      return isAlreadySaved;
    } catch (e) {
      throw Exception('An error occurred while fetching data');
    }
  }

  void getJobFromDatabase() {
    try {
      favouriteJobList = database.values<Job>('job_box');

      notifyListeners();
    } catch (e) {
      throw Exception('An error occurred while fetching data');
    }
  }

  void deleteDataFromDatabase(Job job) async {
    try {
      await database.delete<Job>(boxName: 'job_box', value: job);
      favouriteJobList.removeWhere((element) => element.id == job.id);
      notifyListeners();
    } catch (e) {
      throw Exception('An error occurred while fetching data');
    }
  }

  //this method fetches all the jobs from the api
  Future<void> getJobList() async {
    try {
      var response = await apiService.getRequest(
        url: '${ApiConstants.baseUrl}/jobs',
      );
      jobList = response.map<Job>((json) => Job().fromJson(json)).toList();
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
    bool isAlreadySaved = false;
    try {
      final availableJobApplications = database.values<Candidate>(
        'candidate_box',
      );
      isAlreadySaved = availableJobApplications.any(
        (can) => can.jobId == candidate.jobId,
      );
      if (!isAlreadySaved) {
        await database.add(boxName: 'candidate_box', value: candidate);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('An error occurred while fetching data');
    }

    return isAlreadySaved;
  }

  void getAppliedJobsFromDatabase() {
    try {
      myJobList = database.values<Candidate>('candidate_box');

      notifyListeners();
    } catch (e) {
      throw Exception('An error occurred while fetching data');
    }
  }

  Future<void> addJob(AddJob job) async {
    try {
      await apiService.postRequest(
        url: '${ApiConstants.baseUrl}/jobs',
        body: job.toJson(),
      );
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
    notifyListeners();
  }

  void sortSalary(String value) {
    selectedSalary = value;
    applyFilters();
  }

  void sortJobType(String value) {
    selectedJobType = value;
    applyFilters();
  }

  void sortLocation(String value) {
    selectedLocation = value;
    applyFilters();
  }

  void applyFilters() {
    List<Job> tempList = jobList;

    if (selectedSalary != 'All') {
      final int? threshold = int.tryParse(selectedSalary);
      if (threshold != null) {
        SalaryFilter salaryFilter = SalaryFilter(salary: threshold);
        tempList = salaryFilter.filter(tempList);
      }
    }

    if (selectedJobType != 'All') {
      JobTypeFilter jobTypeFilter = JobTypeFilter(
        selectedJobType.toLowerCase(),
      );
      tempList = jobTypeFilter.filter(tempList);
    }
    if (selectedLocation != 'All') {
      LocationFilter locationFilter = LocationFilter(
        selectedLocation.toLowerCase(),
      );

      tempList = locationFilter.filter(tempList);
    }
    filteredJobList = tempList;
    notifyListeners();
  }
}
