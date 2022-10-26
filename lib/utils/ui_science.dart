import 'package:flutter/material.dart';

class UI {
  MediaQueryData query;
  Orientation orientation;
  BuildContext context;
  double h;
  double w;
  UI({this.query, this.h, this.w, this.orientation});

  double Hcent(H) {
    double height = query.size.width < query.size.height
        ? query.size.height
        : query.size.width;
    double percent = height * (H / 100);
    return percent;
  }

  double Wcent(W) {
    double width = query.size.width > query.size.height
        ? query.size.width
        : query.size.height;
    double percent = width * (W / 100);
    return percent;
  }
}
