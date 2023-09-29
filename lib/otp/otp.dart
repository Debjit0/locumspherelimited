import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/LoginScreen/login.dart';
import 'package:locumspherelimited/Signup%20Screen/signup.dart';
import 'package:pinput/pinput.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            // height: 300,
            width: width,
            padding: const EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Image.asset(
                    'assets/image/loginR.png',
                    width: 150,
                    height: 150,
                  ),*/
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Phone Verification",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Pinput(
                    length: 6,
                     defaultPinTheme: defaultPinTheme,
                     focusedPinTheme: focusedPinTheme,
                     submittedPinTheme: submittedPinTheme,
                    onChanged: (value) {
                      code = value;
                    },
                    showCursor: true,
                    onCompleted: (pin) => print(pin),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: FilledButton.tonal(
                         style: ElevatedButton.styleFrom(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: LoginScreen.verify,
                                    smsCode: code);

                            // Sign the user in (or link) with the credential
                            await auth.signInWithCredential(credential);
                            Get.offAll(() => SignupScreen());
                          } catch (e) {
                            //print('verify error');
                            print(e);
                            Get.snackbar("Invalid OTP", e.toString());
                          }
                        },
                        child: const Text("Verify Phone Number")),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.offAll(() => LoginScreen());
                          },
                          child: const Text(
                            "Edit Phone Number",
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
