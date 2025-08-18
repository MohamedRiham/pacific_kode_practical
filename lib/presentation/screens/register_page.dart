import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pacific_kode_practical/core/widgets/custom_scaffold.dart';
import 'package:pacific_kode_practical/core/widgets/custom_text_field.dart';
import 'package:pacific_kode_practical/domain/models/user_Profile.dart';

import 'package:pacific_kode_practical/presentation/getx/user_getx.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with RestorationMixin {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserGetX>();

  RestorableTextEditingController _nameController =
      RestorableTextEditingController();
  RestorableTextEditingController _emailController =
      RestorableTextEditingController();
  RestorableTextEditingController _ageController =
      RestorableTextEditingController();
  RestorableTextEditingController _mobileController =
      RestorableTextEditingController();

  @override
  void initState() {
    super.initState();

    final user = userController.userProfile.value;
    _nameController = RestorableTextEditingController(text: user.name);
    _emailController = RestorableTextEditingController(text: user.email);
    _ageController = RestorableTextEditingController(
      text: user.age == 0 ? '' : user.age.toString(),
    );
    _mobileController = RestorableTextEditingController(
      text: user.mobileNumber,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'User Registration',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController.value,
                  hintText: "Enter your name",
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController.value,
                  hintText: "Enter your email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _mobileController.value,
                  hintText: "Enter your mobile number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _ageController.value,
                  hintText: "Enter your age",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final oldUser = userController.userProfile.value;

                      UserProfile newUser = UserProfile(
                        name: _nameController.value.text.trim(),
                        email: _emailController.value.text.trim(),
                        age: int.parse(_ageController.value.text.trim()),
                        mobileNumber: _mobileController.value.text.trim(),
                      );
                      String message;
                      if (oldUser.name.isEmpty &&
                          oldUser.email.isEmpty &&
                          oldUser.age == 0 &&
                          oldUser.mobileNumber.isEmpty) {
                        message = "User Registered: ${newUser.name}";
                      } else {
                        message = "Details updated successfully";
                      }
                      userController.save(newUser);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    userController.userProfile.value.name == ''
                        ? "Register"
                        : 'Save',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String? get restorationId => "register_page";
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_nameController, 'name');
    registerForRestoration(_emailController, 'email');
    registerForRestoration(_ageController, 'age');
    registerForRestoration(_mobileController, 'mobile');
  }
}
