import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  final List places;
  final double workLongitude;
  final double workLatitude;
  final String place;
  const HomeScreen(
      {Key key, this.places, this.workLatitude, this.place, this.workLongitude})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _currentLatitude;
  double _currentLongitude;
  bool _atWork = true;
  // latitude tolerance
  double _latTolerance = 0.09;
  // longitude tolerance
  double _longTolerance = 0.09;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {},
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 0.8,
                  child: StreamBuilder<Position>(
                    stream: Geolocator.getPositionStream(
                        locationSettings: locationSettings),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else {
                        _currentLatitude = snapshot.data.latitude;
                        _currentLongitude = snapshot.data.longitude;
                        _comparePosition(_currentLatitude, _currentLongitude);
                        return Column(
                          children: [
                            Text('Location: ${widget.place} '),
                            Text('Location Longitude: ${widget.workLongitude}'),
                            Text('Location Latitude ${widget.workLatitude}'),
                            Text('My Longitude ${_currentLatitude}'),
                            Text('My Latitude ${_currentLongitude}'),
                          ],
                        );
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            SizedBox(
              height: 25.0,
            ),
            Expanded(child: ListView.builder(itemBuilder: (context, int) {
              return Padding(
                padding: EdgeInsets.all(25.0),
                child: Container(
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.width / 0.8,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              );
            }))
          ],
        ),
      ),
    ));
  }

  _comparePosition(lat, long) {
    var _workLatitude = widget.workLatitude;
    var _workLongitude = widget.workLongitude;
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
}
