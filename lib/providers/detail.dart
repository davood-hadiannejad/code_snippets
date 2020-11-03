import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';


String dummyData = '{"id": "vw", "name" : "Volkswagen"}';



class Detail with ChangeNotifier {
  final String authToken;
  String name;

  Detail(
    this.authToken,
    this.name,
  );

  Future<void> fetchAndSetDetail(String id, {init=false}) async {
    var url = '................../api/detail/{}/';
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      //final extractedData = json.decode(response.body) as dynamic;
      final extractedData = json.decode(dummyData) as dynamic;

      if (extractedData == null) {
        return;
      }

      name = extractedData['name'];

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
