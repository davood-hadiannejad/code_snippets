import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Project with ChangeNotifier {
  final int id;
  final String name;
  final String customer;
  final String medium;
  final String brand;
  final String agency;
  final num mn3;
  final num cashRabatt;
  final num naturalRabatt;
  final num bewertung;
  final String comment;
  final String status;
  final String dueDate;


  Project({
    @required this.id,
    @required this.name,
    @required this.customer,
    @required this.medium,
    @required this.brand,
    @required this.agency,
    @required this.mn3,
    @required this.cashRabatt,
    @required this.naturalRabatt,
    @required this.bewertung,
    this.comment,
    @required this.status,
    @required this.dueDate,
  });
}
