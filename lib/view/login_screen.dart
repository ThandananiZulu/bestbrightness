import 'dart:ffi';

import 'package:bestbrightness/helper/general_helper.dart';
import 'package:bestbrightness/view/capture_screen.dart';
import 'package:bestbrightness/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:bestbrightness/controller/user_controller.dart';
import 'package:bestbrightness/services/local_auth_api.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Map signInData = {"username": "", "password": ""};
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;
  Future<bool> authenticated = Future<bool>.value(false);
  GoogleSignInAccount? _currentUser;
  var sessionManager = SessionManager();
  UserController controller = Get.put(UserController());
  @override
  void initState() {
    super.initState();
  }

  facebookLogin() async {
    final accesstoken = await FacebookAuth.instance.accessToken;

    setState(() => {_checking = false});

    if (accesstoken != null) {
      print(accesstoken.toJson());
      print(
          "....................................................................................");
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      _accessToken = accesstoken;

      setState(() => {_userData = userData});
      await sessionManager.set("username", userData["email"]);

      await Get.to(const CaptureScreen());
    } else {
      _fblogin();
    }
  }

  _fblogin() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      print(result.status);
      print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
      _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
      await sessionManager.set("username", userData["email"]);

      await Get.to(const CaptureScreen());
    } else {
      print(result.status);
      print(result.message);
    }
    setState(() {
      _checking = false;
    });
  }

  _fblogout() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  signIn() async {
    Future<bool> authenticated = GeneralHelper.biometricAuth();

    bool isLoggedIn = await authenticated;

    if (isLoggedIn) {
      _formKey.currentState!.save();
      if (_formKey.currentState!.validate()) {
        controller.signIn(signInData);
      }
    } else {
      print("something went wrong");
    }
  }

  signMe() {
    Get.to(const SignupScreen());
  }

  googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn.signIn();

      await _googleSignIn.onCurrentUserChanged
          .listen((GoogleSignInAccount? account) {
        _currentUser = account;
      });
      await sessionManager.set("username", "email");

      await Get.to(const CaptureScreen());
      print(
          ".................................................................................................");
      print(_currentUser);
    } catch (error) {
      print(
          ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
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
                    label: Text('Username'),
                  ),
                  onSaved: (value) {
                    signInData['username'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                  onSaved: (value) {
                    signInData['password'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(onPressed: signIn, child: const Text("LOGIN")),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(
                  Buttons.Google,
                  text: "Sign in with Google",
                  onPressed: () async {
                    Future<bool> authenticateds = GeneralHelper.biometricAuth();

                    bool isLoggedIn = await authenticateds;

                    if (isLoggedIn) {
                      googleLogin();
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                SignInButton(
                  Buttons.Facebook,
                  text: "Sign in with Facebook",
                  onPressed: () async {
                    Future<bool> authenticated = GeneralHelper.biometricAuth();

                    bool isLoggedIn = await authenticated;

                    if (isLoggedIn) {
                      facebookLogin();
                    }
                  },
                ),
                TextButton(
                  onPressed: () =>
                      //print("Already have account")
                      signMe(),
                  // padding: EdgeInsets.only(right: 0),
                  child: Text(
                    "Don't have an account? : Sign up",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
