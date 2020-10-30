import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Summary with ChangeNotifier {
  final String id;
  final String name;
  final Map<dynamic, dynamic> stichtag;
  final Map<dynamic, dynamic> forecast;
  final Map<dynamic, dynamic> gobalrate;
  final Map<dynamic, dynamic> goal;


  Summary({
    @required this.id,
    @required this.name,
    @required this.stichtag,
    @required this.forecast,
    @required this.gobalrate,
    @required this.goal,
  });
}
