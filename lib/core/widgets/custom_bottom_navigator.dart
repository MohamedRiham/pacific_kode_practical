import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/presentation/screens/applied_jobs_page.dart';
import 'package:pacific_kode_practical/presentation/screens/favourite_jobs_page.dart';
import 'package:pacific_kode_practical/presentation/screens/job_list_page.dart';

class CustomBottomNavigator extends StatefulWidget {
  const CustomBottomNavigator({super.key});

  @override
  State<CustomBottomNavigator> createState() => _CustomBottomNavigator();
}

class _CustomBottomNavigator extends State<CustomBottomNavigator>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          TabBarView(
            controller: tabController,
            children: [JobListPage(), FavouriteJobsPage(), AppliedJobsPage()],
          ),

          Align(
            alignment: Alignment.bottomCenter,

            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.work), text: "Jobs"),
                Tab(icon: Icon(Icons.favorite), text: "Favourites"),
                Tab(icon: Icon(Icons.check_circle), text: "Applied"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
