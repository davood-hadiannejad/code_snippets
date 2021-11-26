import 'package:flutter/foundation.dart';

class Agency with ChangeNotifier {
  final String name;
  final String slug;

  Agency({
    required this.name,
    required this.slug,
  });
}
