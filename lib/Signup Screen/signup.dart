

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/Firebase%20Services/services.dart';
import 'package:locumspherelimited/Signup%20Screen/components/drop_down.dart';
import 'package:locumspherelimited/Signup%20Screen/components/text_form_field.dart';
import 'package:locumspherelimited/View%20Models/auth_provider.dart';
import 'package:locumspherelimited/check%20verification/check_verification.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();

  TextEditingController _lastNameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String gender = 'Male';
  String shiftPreference = 'Shift1';
  bool isInit = true;

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      var authProv = Provider.of<AuthProvider>(context, listen: false);
      _firstNameController.text = authProv.firstName;
      _lastNameController.text = authProv.lastName;
      _emailController.text = authProv.email;
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _authProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign Up.", style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 56.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),),
                  const SizedBox(
                    height: 56,
                  ),
                  // Image.asset("assets/images/login.png"),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormFieldWidget(
                          hintText: 'Enter your first name',
                          controller: _firstNameController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormFieldWidget(
                          hintText: 'Enter your last name',
                          controller: _lastNameController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormFieldWidget(
                          hintText: 'Enter your email',
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AppDropdownInput(
                          //hintText: "Gender",
                          options: ["Male", "Female"],
                          value: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value.toString();
                              // state.didChange(newValue);
                            });
                          },
                          getLabel: (String value) => value,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AppDropdownInput(
                          //hintText: "Gender",
                          options: ["Shift1", "Shift2", 'Shift3'],
                          value: shiftPreference,
                          onChanged: (String? value) {
                            setState(() {
                              shiftPreference = value.toString();
                              // state.didChange(newValue);
                            });
                          },
                          getLabel: (String value) => value,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 50,
                        child: FilledButton.tonal(
                            onPressed: () async {
                              //print(shiftPreference);
                              if (_emailController.text == '' ||
                                  _firstNameController.text == '' ||
                                  _lastNameController.text == '') {
                                Get.snackbar(
                                    "Error", "Please fill all the fields");
                              } else {
                                isLoading = true;
                                setState(() {});
                                Services()
                                    .addInitialDetails(
                                  _firstNameController.text,
                                  _lastNameController.text,
                                  _emailController.text,
                                  gender,
                                  shiftPreference,
                                  _authProvider.phoneNumber,
                                )
                                    .then((value) {
                                  Get.to(CheckVerify());
                                  Get.snackbar("Wait until you get verified",
                                      "Wait for sometime until the admins verify you");
                                });
                              }
                            },
                            child: isLoading == false
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Next"),
                                      Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                      )
                                    ],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
