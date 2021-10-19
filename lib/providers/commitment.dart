import 'dart:convert';

import 'package:flutter/foundation.dart';


class Commitment with ChangeNotifier {
  final int id;
  final String customer;
  final String verkaeufer;
  final List<dynamic> medium;
  final List<dynamic> brand;
  final List<dynamic> umsatzcluster;
  final String agentur;
  final int year;
  final int monthStart;
  final int monthEnd;
  final num mn3;
  final num cashRabatt;
  final num naturalRabatt;
  final num mn3Ist;
  final num cashRabattIst;
  final num naturalRabattIst;
  final String comment;
  final String status;


  Commitment({
    @required this.id,
    @required this.customer,
    @required this.verkaeufer,
    @required this.medium,
    @required this.brand,
    @required this.umsatzcluster,
    @required this.agentur,
    @required this.year,
    @required this.monthStart,
    @required this.monthEnd,
    @required this.mn3,
    @required this.cashRabatt,
    @required this.naturalRabatt,
    this.mn3Ist,
    this.cashRabattIst,
    this.naturalRabattIst,
    @required this.comment,
    @required this.status,
  });
}
