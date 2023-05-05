import 'package:bestbrightness/helper/NotificationPlugin.dart';
import 'package:bestbrightness/view/viewitems_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class LocalNotificationScreen extends StatefulWidget{
  @override
  _LocalNotificationScreenState createState() => _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen>{
  @override
  void initState(){
    super.initState();
    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }
  String? val;
  String? vall;
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notification'),
      ),
      body: Expanded(
        child: 
          Center(
            child: ElevatedButton(onPressed: () async{//
              await notificationPlugin.showNotification(val!,vall! );
            },
              child: Text('Send Notifications'),
            ),
          ),
      ),
    );
  }
  onNotificationInLowerVersions(RecievedNotification recievedNotification){


  }

  onNotificationClick(String payload) async {
      print('Payloads $payload');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewitemsScreen(payload: payload),));


  }
}