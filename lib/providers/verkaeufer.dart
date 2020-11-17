import 'dart:convert';

import 'package:flutter/foundation.dart';

class Verkaeufer with ChangeNotifier {
  final String email;
  final String name;
  final bool selected;

  Verkaeufer({
    @required this.email,
    @required this.name,
    @required this.selected,
  });
}