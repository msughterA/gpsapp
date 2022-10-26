import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:gpsapp/models/clocking_models.dart';

void main() {
  runApp(MaterialApp(home: ClockingScreen()));
}

class ClockingScreen extends StatefulWidget {
  ClockingScreen({Key key}) : super(key: key);

  @override
  _ClockingScreenState createState() => _ClockingScreenState();
}

class _ClockingScreenState extends State<ClockingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Sizer(
      builder: (context, orientation, deviceType) {
        return Container(
          padding: EdgeInsets.all(10.0),
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.settings_outlined))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            // Synchronise the data
                          },
                          icon: Icon(Icons.sync_outlined)),
                      Text('0')
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        // Show signal availability
                      },
                      icon: Icon(Icons.signal_cellular_4_bar_outlined)),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                  child: Container(
                child: GridView.builder(
                    itemCount: clockTileModels.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / 1.6, crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ClockTile(
                          label: clockTileModels[index].label,
                          color: clockTileModels[index].color,
                        ),
                      );
                    }),
              ))
            ],
          ),
        );
      },
    )));
  }
}

class ClockTile extends StatelessWidget {
  final Color color;
  final String label;
  const ClockTile({Key key, this.color, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.face_unlock_outlined,
            size: 50,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            label ?? '',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }
}
