import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/otp/otp.dart';
import 'package:locumspherelimited/View%20Models/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String verify = '';
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String countryCode = '+44';
  var isLoading = false;
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(child: SvgPicture.asset("assets/images/login.svg",height: 350,),alignment: Alignment.bottomCenter,),
              )),
              Expanded(
                child: Container(
        
                  //  height: 300,
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Log In.", style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 56.0,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),),
                      const SizedBox(
                        height: 36,
                      ),
                      // Image.asset("assets/images/login.png"),
                      Form(
                        key: _formKey,
                        child: SizedBox(
                          // height: 60,
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                  height: 60,
                                  width: 90,
                                  child: FilledButton.tonal(
                                      onPressed: () {},
                                      child: const Text("+44"))),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 40) -
                                    90 -
                                    16,
                                child: TextFormField(
                                  controller: phoneController,
                                  style: const TextStyle(
                                      //color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // ignore: body_might_complete_normally_nullable
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a phone number';
                                    } else if (value.length < 7 ||
                                        value.length > 15) {
                                      return 'PLease enter a valid phone number';
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                      ),
                                    ),
                                    hintText: 'Enter Your mobile number',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: FilledButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  isLoading = true;
                                  setState(() {
                                  });
                                  print("${countryCode + phoneController.text}");
                                  try {
                                    Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .setPhoneNumber =
                                        "${countryCode + phoneController.text}";
                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber:
                                          "${countryCode + phoneController.text}",
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {},
                                      verificationFailed:
                                          (FirebaseAuthException e) {},
                                      codeSent: (String verificationId,
                                          int? resendToken) {
                                        LoginScreen.verify = verificationId;
              
                                        Get.offAll(OTP());
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {},
                                    );
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(e.toString()),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: isLoading==false?Text("Get OTP"):Center(child: CircularProgressIndicator(color: Colors.white,),)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
