import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Customer with ChangeNotifier {
  final String name;
  final String slug;
  final String konzern;

  Customer({
    @required this.name,
    @required this.slug,
    this.konzern,
  });
}
