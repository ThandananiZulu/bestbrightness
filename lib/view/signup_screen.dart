import 'package:bestbrightness/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bestbrightness/controller/user_controller.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  Map loginData = {"fullname": "", "username": "", "password": ""};

  UserController controller = Get.put(UserController());

  signUp() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      controller.signUp(loginData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child:  Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image(image: AssetImage('assets/dishliquid.png')),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Name and surname:'),
                ),
                onSaved: (value) {
                  loginData['fullname'] = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'name & surname required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Username:'),
                ),
                onSaved: (value) {
                  loginData['username'] = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username required';
                  }
                   if (value.isEmpty ||
                        !RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                            .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                  return null;
                  
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Password:'),
                ),
                onSaved: (value) {
                  loginData['password'] = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  if (value.isEmpty || value.length < 8) {
                      return 'Password should not be less than 8 characters';
                    }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Confirm Password:'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'confirmaton password required';
                  }
                  if (value != loginData['password']) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: signUp, child: const Text("SUBMIT")),
              TextButton(
                onPressed: () {
                  //print("Already have account")
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                // padding: EdgeInsets.only(right: 0),
                child: Text(
                  'Already have an account? : Login',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ),
              // Add TextFormFields and ElevatedButton here.
            ],
          ),
        ),
      ),
   ), );
  }
}
