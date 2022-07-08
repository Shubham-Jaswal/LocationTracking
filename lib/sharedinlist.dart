import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:time/time.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class shared extends StatefulWidget {
  const shared({Key? key}) : super(key: key);

  @override
  State<shared> createState() => _sharedState();
}

class _sharedState extends State<shared> {
  int counter = 1;
  final List<String> data = [];
  var battery = Battery();

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
          children: [
            Text('Data'),
            FloatingActionButton(onPressed: () async {
              await batteryinfo();
              await sharedlistset();
              sharedlistget();
            }),
            FloatingActionButton(onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              counter = 1;
              pref.clear();
              try {} catch (e) {
                Fluttertoast.showToast(msg: e.toString());
              }
            })
          ],
        ),
      ),
    );
  }

  Future sharedlistset() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('data' + counter.toString(), data);
    counter = counter + 1;
  }

  Future sharedlistget() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      for (int a = 1; a <= 100; a++) {
        print("---------------------------------------------");
        List<String> dataget =
            pref.getStringList('data' + a.toString()) as List<String>;
        //String add = address(dataget[1]);
        String url = "http://192.168.0.243/php/test.php?";
        url = "${url}bat=${dataget[0]}&";
        url = "${url}wifi=${dataget[1]}&";
        url = "${url}air=${dataget[2]}&";
        url = "${url}time=${dataget[3]}";
        var req = await http.get(Uri.parse(url));
        print(req.body.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  batteryinfo() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var status = await AirplaneModeChecker.checkAirplaneMode();
    var battery = Battery();
    data.clear();

    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
      var wifiBSSID = await WifiInfo().getWifiBSSID() as String;
      var wifiIP = await WifiInfo().getWifiIP() as String;
      var wifiName = await WifiInfo().getWifiName() as String;
      String batterymobile = (await battery.batteryLevel).toString();
      String time=(DateTime.now()).toString();
      //String batterymobile1=await battery.batteryState as String;
      data.add(batterymobile.toString());
      //data.add(batterymobile1.toString());
      data.add(wifiName);
      data.add(time);

    }
    if (status == AirplaneModeStatus.on) {
      String airplanemodecheck = 'Airplane Mode On';
      data.add(airplanemodecheck);
    } else if (status == AirplaneModeStatus.off) {
      String airplanemodecheck1 = 'Airplane Mode Off';
      data.add(airplanemodecheck1);
    } else {
      String noconnectivity = 'Not connected to anything';
      data.add(noconnectivity);
    }
  }

  /*String address(a) {
    String change = "Wifinomore";
    return change;
  }*/
}
/*
class userdata{
  late  String geo;
  late String time;


}*/
