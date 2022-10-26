import 'package:flutter/material.dart';
import 'mark_location_screen.dart';

void main() {
  runApp(MaterialApp(
    home: SetLocationScreen(),
  ));
}

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({Key key}) : super(key: key);

  @override
  _SetLocationScreenState createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final List places = [
    'Fcmb',
    'First Bank',
    'Zenith Bank',
    'Stetis',
    'Flexisaf',
    'Datalab',
    'NCC',
    'Galaxy Backbone',
    'ByteWorks',
    'Ehealth4Everyone'
  ];
  String _selectedPlace;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedPlace = places[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 0.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      height: 40.0,
                      child: Center(
                        child: Text(
                          '${_selectedPlace}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: List.generate(places.length, (index) {
                          return ListTile(
                            onTap: () {
                              // Set the Selected place to this index
                              setState(() {
                                _selectedPlace = places[index];
                              });
                            },
                            selected:
                                _selectedPlace == places[index] ? true : false,
                            selectedTileColor: Colors.green,
                            title: Text(places[index]),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MapPage(
                              place: _selectedPlace,
                            );
                          }));
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Mark your Location'),
                              SizedBox(
                                width: 8.0,
                              ),
                              Icon(Icons.gps_fixed_outlined)
                            ],
                          ),
                          height: MediaQuery.of(context).size.height / 18,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
