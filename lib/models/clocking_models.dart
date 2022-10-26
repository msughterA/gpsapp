import 'package:flutter/material.dart';

class ClockTileModel {
  final Color color;
  final String label;
  ClockTileModel({this.color, this.label});
}

List clockTileModels = [
  ClockTileModel(color: Colors.green, label: 'Clock in'),
  ClockTileModel(color: Colors.orange, label: 'Clock out'),
  ClockTileModel(color: Colors.blue, label: 'Break on'),
  ClockTileModel(color: Colors.red, label: 'Break off'),
];
