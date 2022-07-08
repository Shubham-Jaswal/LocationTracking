import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:untitled2/notification_service.dart';


//-------------------------ALarmManager setting background Service.........................//

Future<void> alarm() async {
  final int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 30), helloAlarmID, test);
 /* var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    Fluttertoast.showToast(msg: 'Online Service Enabled');
  }
  else if (connectivityResult == ConnectivityResult.wifi) {
    Fluttertoast.showToast(msg: 'Online Service Enabled');
  }
  else {
    Fluttertoast.showToast(msg: 'Offline Service Enabled');
  }*/

}
//.......................................To Be passed inside AlarmManager function.....................................................................//
 Future<Position> test() async {
  print('Started');
//final SharedPreferences pref=await SharedPreferences.getInstance();
final Position position = await Geolocator.getCurrentPosition(
desiredAccuracy: LocationAccuracy.best);
final String _setData='${position.latitude},${position.longitude}';
/* pref.setString('data', _setData);
    final String? _getData=await pref.getString('data');
    print('Set:${_setData}');
    print('Get:${_getData}');*/
Fluttertoast.showToast(msg:"$_setData");
print('$_setData'+DateTime.now().toString());
return position;

}
//......................................Function to get location when Offline.............................................................................//


Future<void>  getCurrentLocationOnPressOffline() async {
  LocationPermission permission;
  bool serviceIsEnabled;
  serviceIsEnabled =  await Geolocator.isLocationServiceEnabled();

  if (!serviceIsEnabled) {
    Fluttertoast.showToast(msg: 'Location Services are Disabled');
    Geolocator.openLocationSettings();
  }
  permission =  await Geolocator.checkPermission();
  if (serviceIsEnabled == true) {
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
          msg: 'Enable Location Permission for track_module');
      permission =  await Geolocator.requestPermission();
    }
  }
  if (serviceIsEnabled == true) {
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: 'Enable Location Permission for track_module');
      permission = Geolocator.openAppSettings() as LocationPermission;
    }
  }
  /*Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _sharedprefsetdata =
    'Lat->${position.latitude}   Long->${position.longitude}';
    print('GETONPRESS:${_sharedprefsetdata}');
    setState(() {
      _userlocationoffline = 'Lat->${position.latitude}   Long->${position.longitude}';
    });*/
  alarm();
}
//..................................................................................................................//




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  String? _userlocationoffline;
  String? _userlocationonline;
  String? dataforonline;
  String _sharedprefsetdata = '';
  String? _sharedprefgetdata = '';
  static const String _backgroundName =
      'dev.fluttercommunity.plus/android_alarm_manager_background';
  static const _channel = MethodChannel(_backgroundName, JSONMethodCodec());
  DateTime time = DateTime.now();






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    permissions();


    //alarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Offline:${_userlocationoffline}'),
                     Text('Online:${_userlocationonline}'),

            ElevatedButton(
                onPressed: () async {
                  var connectivityResult = await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile) {
                    getCurrentLocationOnPressOnline();
                    // I am connected to a mobile network.
                    Fluttertoast.showToast(msg: 'I am connected to a mobile network.');
                  }
                  else if (connectivityResult == ConnectivityResult.wifi) {
                    getCurrentLocationOnPressOnline();
                    // I am connected to a wifi network.
                    Fluttertoast.showToast(msg: 'Wifi');
                  }
                  else {
                    Fluttertoast.showToast(msg: 'No Network');
                    getCurrentLocationOnPressOffline();
                  }

                },
                child: Text('Press')),
            TextButton(
                onPressed: () async {
                  cancel(0);
                },
                child: Text('Stop')),
          ],
        ),
      ),
    );
  }


//...................Function to cancel/Stop the background service............................................//
  static Future<bool> cancel(int id) async {
    final r = await AndroidAlarmManager.cancel(id);
    if(r==null)
      {
       return false;
      }
    print('Service Stopped');
    return r;
  }
//...............Handling permissions................................................//
 Future permissions() async {
    LocationPermission permission;
    bool serviceIsEnabled;
    serviceIsEnabled =  await Geolocator.isLocationServiceEnabled();

    if (!serviceIsEnabled) {
      Fluttertoast.showToast(msg: 'Location Services are Disabled');
      Geolocator.openLocationSettings();
    }
    permission =  await Geolocator.checkPermission();
    if (serviceIsEnabled == true) {
      if (permission == LocationPermission.denied) {
        permission =  await Geolocator.requestPermission();
      }
    }
    if (serviceIsEnabled == true) {
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: 'Enable Location Permission for track_module');
        permission = Geolocator.openAppSettings() as LocationPermission;
      }
    }
  }

//---------------------------------SharedPreferences for Offline Location Data Storage------------------------------//

  Future<void> setDataOffline() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('data', _sharedprefsetdata);
    print('SETPress:${_sharedprefsetdata}');
  }

  Future<void> getDataOffline() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _sharedprefgetdata = pref.getString('data');
    print('GETPress:${_sharedprefgetdata}');
  }
  //...............................................................//


  //.......................Function to get location when user is Online...............................................................................................//
  Future getCurrentLocationOnPressOnline() async {
    LocationPermission permission;
    bool serviceIsEnabled;
    serviceIsEnabled =  await Geolocator.isLocationServiceEnabled();

    if (!serviceIsEnabled) {
      Fluttertoast.showToast(msg: 'Location Services are Disabled');
      Geolocator.openLocationSettings();
    }
    permission =  await Geolocator.checkPermission();
    if (serviceIsEnabled == true) {
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: 'Enable Location Permission for track_module');
        permission =  await Geolocator.requestPermission();
      }
    }
    if (serviceIsEnabled == true) {
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: 'Enable Location Permission for track_module');
        permission = Geolocator.openAppSettings() as LocationPermission;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _userlocationonline = 'Lat->${position.latitude}   Long->${position.longitude}';
    });
    alarm();
    return position;
  }


}
