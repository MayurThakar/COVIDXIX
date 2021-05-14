import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:covidxix/APIs.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(home: Main()));

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  double deviceWidth, deviceHeight;
  String country = 'World Wide',
      cases = 'N/A',
      active = 'N/A',
      deaths = 'N/A',
      recovered = 'N/A',
      celsius = 'N/A',
      fahrenheit = 'N/A',
      condition = 'N/A',
      date = 'N/A',
      time = 'N/A',
      timeZone = 'N/A',
      sunrise = 'N/A',
      sunset = 'N/A',
      globallyLocally = 'iCon/Local.png',
      mode = 'iCon/Dark.png';

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    ProgressDialog proDlg =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    proDlg.show();
    Response res = await get('https://corona.lmao.ninja/v2/all');
    Map stats = jsonDecode(res.body);
    setState(() {
      cases = stats['cases'].toString();
      active = stats['active'].toString();
      deaths = stats['deaths'].toString();
      recovered = stats['recovered'].toString();
    });
    proDlg.hide();
  }

  void reqDate(String req) async {
    var api = new API();
    ProgressDialog proDlg =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    proDlg.show();
    Response res1 = await get('https://corona.lmao.ninja/v2/countries/$req');
    Response res2 = await get('http://api.weatherapi.com/v1/current.json?key=' +
        api.weatherapi +
        '&q=$req');
    Response res3 = await get('https://api.ipgeolocation.io/astronomy?apiKey=' +
        api.ipgeolocation +
        '&location=$req');
    Response res4 = await get(
        'https://restcountries.eu/rest/v2/name/$req?fields=timezones');
    Map stats = jsonDecode(res1.body);
    Map weather = jsonDecode(res2.body);
    Map ipgeolocation = jsonDecode(res3.body);
    List timeZones = jsonDecode(res4.body);
    String dateNtime = DateFormat('dd-MMM-yyyy hh:mm aa').format(DateTime.parse(
        (ipgeolocation['date'].toString()) +
            ' ' +
            ipgeolocation['current_time'].toString()));

    setState(() {
      country = req.toUpperCase();
      cases = stats['cases'].toString();
      active = stats['active'].toString();
      deaths = stats['deaths'].toString();
      recovered = stats['recovered'].toString();
      celsius = weather['current']['temp_c'].toString();
      fahrenheit = weather['current']['temp_f'].toString();
      condition = weather['current']['condition']['text']
          .toString()
          .replaceAll(' ', '\n');
      date = dateNtime.substring(0, dateNtime.indexOf(' '));
      time = dateNtime.substring(dateNtime.indexOf(' ') + 1);
      timeZone = (timeZones
              .toString()
              .substring(14, timeZones.toString().indexOf(',')))
          .replaceAll(']}', '');
      sunrise = 'Sunrise: ' + ipgeolocation['sunrise'].toString();
      sunset = 'Sunset: ' + ipgeolocation['sunset'].toString();
    });
    proDlg.hide();
  }

  Future<bool> onBkPress() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to EXIT?'),
        actions: [
          FlatButton(
            child: Text('Feedback'),
            onPressed: () {},
          ),
          FlatButton(
            child: Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: WillPopScope(
        onWillPop: onBkPress,
        child: Scaffold(
          appBar: AppBar(
            title:
                Text('Covidxix', style: TextStyle(fontSize: deviceWidth * .08)),
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: deviceWidth * .1,
                onPressed: () => showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset('iCon/iCon.png'),
                    applicationName: 'Covidxix',
                    applicationVersion: '2.1',
                    applicationLegalese: 'Copyright(c) 2020, CODECOL',
                    children: [
                      Text(
                          'Covidxix is an statistics tracker for corona-virus. build using Flutter open-source UI framework\n' +
                              'APIs is provided by'),
                    ]),
              )
            ],
          ),
          floatingActionButton: SpeedDial(
            curve: Curves.decelerate,
            animatedIcon: AnimatedIcons.menu_close,
            overlayColor: Colors.grey,
            animatedIconTheme: IconThemeData.fallback(),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.black,
            child: Icon(Icons.menu),
            children: [
              SpeedDialChild(
                  child: Image.asset('$globallyLocally'),
                  backgroundColor: Colors.purpleAccent,
                  label: '$globallyLocally'
                      .substring(5, globallyLocally.indexOf('.'))),
              SpeedDialChild(
                  child: Image.asset('$mode'),
                  backgroundColor: Colors.purpleAccent,
                  label: '$mode'.substring(5, mode.indexOf('.')) + ' mode')
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * .02,
                ),
                Text('$country', style: TextStyle(fontSize: deviceWidth * .13)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: deviceWidth * .49,
                      height: deviceHeight * .16,
                      child: Card(
                        color: Colors.yellow,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('$cases',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .08,
                                      color: Colors.white)),
                              Text('Cases',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .07,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth * .49,
                      height: deviceHeight * .16,
                      child: Card(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('$active',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .08,
                                      color: Colors.white)),
                              Text('Active',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .07,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: deviceWidth * .49,
                      height: deviceHeight * .16,
                      child: Card(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('$deaths',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .08,
                                      color: Colors.white)),
                              Text('Deaths',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .07,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth * .49,
                      height: deviceHeight * .16,
                      child: Card(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('$recovered',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .08,
                                      color: Colors.white)),
                              Text('Recovered',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .07,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: deviceWidth * .99,
                  height: deviceHeight * .15,
                  child: Card(
                    color: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$celsius',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .1,
                                      color: Colors.white)),
                              Text('Celsius',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .06,
                                      color: Colors.white)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$fahrenheit',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .1,
                                      color: Colors.white)),
                              Text('Fahrenheit',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .06,
                                      color: Colors.white)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$condition',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .09,
                                      color: Colors.white))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: deviceWidth * .99,
                  height: deviceHeight * .20,
                  child: Card(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('$date',
                              style: TextStyle(
                                  fontSize: deviceWidth * .09,
                                  color: Colors.white)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$time',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .08,
                                      color: Colors.white)),
                              Text('$timeZone',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .08,
                                      color: Colors.white)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$sunrise',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .06,
                                      color: Colors.white)),
                              Text('$sunset',
                                  style: TextStyle(
                                      fontSize: deviceWidth * .06,
                                      color: Colors.white)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                        onSubmitted: (req) => reqDate(req
                            .replaceAll(new RegExp('[^A-Za-z]'), "")
                            .toLowerCase()),
                        style: TextStyle(fontSize: deviceWidth * .06),
                        autocorrect: true,
                        decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.search, size: deviceWidth * .09),
                            hintText: 'Search country...',
                            hintStyle: TextStyle(
                                fontSize: deviceWidth * .06,
                                color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                              borderSide: BorderSide(color: Colors.grey),
                            ))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
