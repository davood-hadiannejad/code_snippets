import 'dart:convert';

import 'package:flutter/foundation.dart';

class Verkaeufer with ChangeNotifier {
  final String email;
  final String name;
  bool selected;
  bool isCurrentUser;
  bool isGroup;

  Verkaeufer({
    @required this.email,
    @required this.name,
    @required this.selected,
    @required this.isCurrentUser,
    @required this.isGroup,
  });
}
