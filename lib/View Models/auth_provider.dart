import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phoneNumber = '';
  String _gender = '';
  String _shiftPreference = '';

  get firstName => _firstName;
  get lastName => _lastName;
  get email => _email;
  get phoneNumber => _phoneNumber;
  get gender => _gender;
  get shiftPreference => _shiftPreference;

  set setFirstName(value) => _firstName = value;
  set setLastName(value) => _lastName = value;
  set setEmail(value) => _email = value;
  set setPhoneNumber(value) => _phoneNumber = value;
  set setgender(value) => _gender = value;
  set setshiftPreference(value) =>_shiftPreference = value;
}
