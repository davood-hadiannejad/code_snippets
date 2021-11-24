import 'package:flutter/foundation.dart';

class Mandant with ChangeNotifier {
  final String name;
  final String slug;
  final List<dynamic> brands;

  Mandant({
    @required this.name,
    @required this.slug,
    @required this.brands,
  });
}
