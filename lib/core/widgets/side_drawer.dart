import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/presentation/get_x/user_get_x.dart';
import 'package:pacific_kode_practical/presentation/screens/register_page.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({super.key});
  final userController = Get.find<UserGetX>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  'assets/images/User Avatar.png',
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                userController.userProfile.value.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          userController.userProfile.value.name == ''
                              ? 'Sign-Up'
                              : 'Edit-Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.restorablePush(
                            context,
                            RegisterPage.myRouteBuilder,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
