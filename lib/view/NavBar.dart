import 'package:bestbrightness/view/delivery_screen.dart';
import 'package:bestbrightness/view/pickup_screen.dart';
import 'package:bestbrightness/view/viewitems_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'capture_screen.dart';
import 'login_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 25,
          ),
          const ListTile(
            title: Center(
              child: Text(''
                  'MENU'),
            ),
            subtitle: Center(child: Text("BEST BRIGHTNESS")),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.book_online),
            title: const Text('Capture Inventory'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CaptureScreen())), //SignOut Page
          ),
          ListTile(
            leading: Icon(Icons.inventory_rounded),
            title: const Text('Delivery Slip'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DeliveryScreen())), //SignOut Page
          ),
          ListTile(
            leading: Icon(Icons.price_check_outlined),
            title: const Text('Pickup Slip'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PickupScreen())), //SignOut Page
          ),
          ListTile(
            leading: Icon(Icons.view_agenda_outlined),
            title: const Text('View Inventory'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => ViewitemsScreen())), //SignOut Page
            //Home Page
          ),
           ListTile(
            leading: Icon(Icons.graphic_eq_outlined),
            title: const Text('Statistics'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => ViewitemsScreen())), //SignOut Page
            //Home Page
          ),
          ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () async => {
                    await logout(),
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    )),
                  } //SignOut Page
              //Drivers Page with table
              ),
        ],
      ),
    );
  }

  logout() async {
    var sessionManager = await SessionManager();

    await sessionManager.set("username", "");
    dynamic id = await SessionManager().get("username");
     await FacebookAuth.instance.logOut();
   final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
    
  }
}
