import 'package:bestbrightness/view/delivery_screen.dart';
import 'package:bestbrightness/view/login_screen.dart';
import 'package:bestbrightness/view/pickup_screen.dart';
import 'package:bestbrightness/view/signup_screen.dart';
import 'package:bestbrightness/view/viewitems_screen.dart';
import 'package:get/get.dart';

import 'view/capture_screen.dart';

/// Routes name to directly navigate the route by its name
class Routes {
  static String signup = '/signup';
  static String login = '/login';
  static String capture = '/capture';
   static String viewitems = '/viewitems';
  static String delivery = '/delivery';
  static String pickup = '/pickup';
   // static String screen6 = '/screen6';
}

/// Add this list variable into your GetMaterialApp as the value of getPages parameter.
/// You can get the reference to the above GetMaterialApp code.
final getPages = [
  GetPage(
    name: Routes.signup,
    page: () => const SignupScreen(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginScreen(),
  ),
  GetPage(
    name: Routes.capture,
    page: () => const CaptureScreen(),
  ),
  GetPage(
    name: Routes.viewitems,
    page: () => ViewitemsScreen(),
  ),
  GetPage(
    name: Routes.delivery,
    page: () => const DeliveryScreen(),
  ),
  GetPage(
    name: Routes.pickup,
    page: () => const PickupScreen(),
  ),
  // GetPage(
  //   name: Routes.screen6,
  //   page: () => const Screen6(),
  // ),
];
