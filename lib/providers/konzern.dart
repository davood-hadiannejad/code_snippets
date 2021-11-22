import 'package:flutter/foundation.dart';

class Konzern with ChangeNotifier {
  final String name;
  final String slug;

  Konzern({
    @required this.name,
    @required this.slug,
  });
}
