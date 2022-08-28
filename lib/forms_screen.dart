import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forms_demo/models/person.dart';

class FormsScreen extends StatefulWidget {
  FormsScreen({Key? key}) : super(key: key);

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formsKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _person = Person();

  bool isValidEmail(String? value) {
    String regex =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(regex);

    if (value != null && value.isNotEmpty && regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  bool isValidPassword(String? value) {
    /*
    Minimum eight characters, at least one letter and one number
    "^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"

    Minimum eight characters, at least one letter, one number and one special character
    "^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"

    Minimum eight characters, at least one uppercase letter, one lowercase letter and one number
    "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"

    Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character
    "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"

    Minimum eight and maximum 10 characters, at least one uppercase letter, one lowercase letter, one number and one special character
    "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$"
    */

    //Minimum eight characters, at least one letter, one number and one special character
    String regex = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';

    RegExp regExp = RegExp(regex);

    if (value != null && value.isNotEmpty && regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Complete your profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formsKey,
            autovalidateMode: AutovalidateMode.always,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      hintText: 'Please fill in your first name',
                      suffixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    onSaved: (value) => _person.firstName = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Last name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _person.lastName = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email address'),
                    validator: (value) => !isValidEmail(value) ? 'Please enter a valid e-mail address' : null,
                    onSaved: (value) => _person.email = value,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) =>
                        !isValidPassword(value) ? 'Password must be 8 characters long, one letter, one number, one special character' : null,
                    onSaved: (value) => _person.password = value,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: const InputDecoration(labelText: 'Confirm password'),
                    validator: (value) {
                      if (value == null || value != _passwordController.text) {
                        return 'Passwords are not equal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'PIN'),
                    onSaved: (value) => _person.PIN = value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formsKey.currentState!.validate()) {
                          _formsKey.currentState!.save();

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(content: Text('Profile completed. Thank You!'));
                              });

                          debugPrint(
                              'Firstname: ${_person.firstName} Lastname: ${_person.lastName} Email: ${_person.email} Password: ${_person.password} PIN: ${_person.PIN}');
                        }
                      },
                      child: const Text(
                        'Complete your profile',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
