import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AOB with ChangeNotifier {
  final String medium;
  final String brand;
  final String agency;
  final num goal;
  final num offen;
  final num gebucht;

  AOB({
    @required this.medium,
    @required this.brand,
    @required this.agency,
    @required this.gebucht,
    @required this.offen,
    @required this.goal,
  });
}
