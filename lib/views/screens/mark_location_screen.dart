import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'home_screen.dart';

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MapPage());
  }
}

class MapPage extends StatefulWidget {
  final String place;
  const MapPage({Key key, this.place}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double _workLongitude;
  double _workLatitude;
  double _currentLatitude;
  double _currentLongitude;
  bool _isSet = false;
  bool _atWork = true;
  bool _isSetting = false;
  // latitude tolerance it 0.09 degrees
  double _latTolerance = 0.09;
  // longitude tolerance is 0.09 degrees
  double _longTolerance = 0.09;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: StreamBuilder<Position>(
          stream:
              Geolocator.getPositionStream(locationSettings: locationSettings),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Text('done');
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              // return snapshot.data

              _currentLatitude = snapshot.data.latitude;
              _currentLongitude = snapshot.data.longitude;

              if (_isSet) {
                _comparePosition(
                    snapshot.data.latitude, snapshot.data.longitude);
              }
              return Stack(children: [
                FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                        snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 13.0,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(snapshot.data.latitude,
                              snapshot.data.longitude),
                          builder: (ctx) => Container(
                            decoration: BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              // Go back to the previous screen
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new_outlined)),
                        Text(
                          'Your at ${widget.place}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isSet = false;
                            });
                          },
                          icon: Icon(Icons.refresh_outlined),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              'Lat: ${_currentLatitude}  Long: ${_currentLongitude}'),
                          _isSet
                              ? Icon(
                                  Icons.gps_fixed_outlined,
                                  size: 50,
                                  color: _atWork ? Colors.blue : Colors.red,
                                )
                              : Icon(
                                  Icons.gps_not_fixed_outlined,
                                  size: 50,
                                ),
                          _isSet
                              ? _atWork
                                  ? Text('At work')
                                  : Text('Away')
                              : Text('Location not set'),
                          GestureDetector(
                              onTap: () async {
                                // Get the user's current location
                                if (_isSet == true) {
                                  // Push to the to the Home Screen
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomeScreen(
                                      place: widget.place,
                                    );
                                  }));
                                } else {
                                  if (_isSetting == false) {
                                    _isSetting = true;

                                    print('Setting');

                                    setState(() {
                                      _isSetting = false;
                                      _isSet = true;
                                      _workLatitude = _currentLatitude;
                                      _workLongitude = _currentLongitude;
                                    });
                                  }
                                }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 12.0, right: 12.0),
                                child: Container(
                                  child: Center(
                                    child: _isSet
                                        ? Text('Save')
                                        : _isSetting
                                            ? CircularProgressIndicator()
                                            : Text('Set Location'),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height / 18,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))
              ]);
            }
          },
        ),
      ),
    ));
  }

  _comparePosition(lat, long) {
    print('work latitude is ${_workLatitude} and current Latitude is ${lat}');
    print(
        'work Longitude is ${_workLongitude} and current Longitude is ${long}');
    // Give an error tolerance of + or - 0.000804
    if ((_workLatitude >= lat && _workLatitude <= lat + _latTolerance) &&
        (_workLongitude >= long && _workLongitude <= long + _longTolerance)) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _atWork = true;
        });
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _atWork = false;
        });
      });
    }
  }

  Future<Position> _getInstatenousPosition() async {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
