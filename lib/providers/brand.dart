import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Brand with ChangeNotifier {
  final String name;
  final String slug;

  Brand({
    @required this.name,
    @required this.slug,
  });
}
