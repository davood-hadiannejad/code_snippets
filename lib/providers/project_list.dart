import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './verkaeufer.dart';
import './project.dart';

String dummyData =
    '[{"id": 1, "name" : "Weinachtsproject", "customer": "Volkswagen", "medium": "TV", "brand": "Nick", "agency": "Initiative", "mn3": 500000, "cashRabatt": 10, "naturalRabatt": 5, "bewertung": 75, "comment": "", "status": "offen", "dueDate": "2020-11-30"}, '
    '{"id": 2, "name" : "Neu Jahrs Projekt", "customer": "Volkswagen", "medium": "TV", "brand": "Nick", "agency": "Initiative", "mn3": 600000, "cashRabatt": 5, "naturalRabatt": 5, "bewertung": 50, "comment": "das wird super toll!", "status": "offen", "dueDate": "2020-12-30"}, '
    '{"id": 3, "name" : "Fenbruar Projekt", "customer": "Volkswagen", "medium": "TV", "brand": "Nick", "agency": "Initiative", "mn3": 800000, "cashRabatt": 11, "naturalRabatt": 1, "bewertung": 100, "comment": "das wird super toll!das wird super toll! das wird super toll! das wird super toll! das wird super toll!das wird super toll! das wird super toll!", "status": "offen", "dueDate": "2021-02-30"}]';

class ProjectList with ChangeNotifier {
  List<Project> _items = [];
  List<Project> _activeItems = [];

  final String authToken;

  ProjectList(this.authToken, this._items);

  List<Project> get items {
    return [..._activeItems];
  }

  List<Project> sortByField(field, {ascending = false}) {
    if (field == 'mb3') {
      if (ascending) {
        _activeItems.sort((a, b) => b.mn3.compareTo(a.mn3));
      } else {
        _activeItems.sort((a, b) => a.mn3.compareTo(b.mn3));
      }
    } else if (field == 'bewertung') {
      if (ascending) {
        _activeItems.sort((a, b) => b.bewertung.compareTo(a.bewertung));
      } else {
        _activeItems.sort((a, b) => a.bewertung.compareTo(b.bewertung));
      }
    } else if (field == 'mb3_bewertet') {
      if (ascending) {
        _activeItems.sort((a, b) {
          var aBewertet = a.mn3 * a.bewertung;
          var bBewertet = b.mn3 * b.bewertung;
          return bBewertet.compareTo(aBewertet);
        });
      } else {
        _activeItems.sort((a, b) {
          var aBewertet = a.mn3 * a.bewertung;
          var bBewertet = b.mn3 * b.bewertung;
          return aBewertet.compareTo(bBewertet);
        });
      }
    } else if (field == 'dueDate') {
      if (ascending) {
        _activeItems.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      } else {
        _activeItems.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      }
    }

    return [..._activeItems];
  }

  Project findById(int id) {
    return _items.firstWhere((project) => project.id == id);
  }

  Future<void> searchByName(String searchString) async {
    _activeItems = _items
        .where((project) =>
            project.name.toLowerCase().startsWith(searchString.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> fetchAndSetProjectList({bool init = false, Verkaeufer verkaeufer}) async {
    var url =
        'http://hammbwdsc02:96/api/projects/?email=magdalena.idziak@visoon.de';
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData = json.decode(utf8.decode(response.bodyBytes) ) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Project> loadedProjectList = [];
      extractedData.forEach((project) {
        loadedProjectList.add(
          Project(
            id: project['id'],
            name: project['name'],
            customer: project['kunde'],
            medium: project['medium'],
            brand: project['brand'],
            agency: project['agentur'],
            mn3: project['mn3'],
            cashRabatt: project['cashRabatt'],
            naturalRabatt: project['naturalRabatt'],
            bewertung: project['bewertung'],
            comment: project['comment'],
            dueDate: project['dueDate'],
            status: project['status'],
          ),
        );
      });
      _items = loadedProjectList;
      _activeItems = loadedProjectList;

      if (init != true) {
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProject(
    String name,
    String customer,
    String medium,
    String brand,
    String agency,
    double mn3,
    double cashRabatt,
    double naturalRabatt,
    int bewertung,
    String comment,
    String dueDate,
    String status,
  ) async {
    var url = 'http://hammbwdsc02:96/api/projects/';
    try {
      final response = await http.post(url, headers: {
        "Authorization": "Bearer $authToken"
      }, body: {
        'name': name,
        'kunde': customer,
        'verkaeufer': 'magdalena.idziak@visoon.de',
        'medium': medium,
        'brand': brand,
        'agentur': agency,
        'mn3': mn3.toString(),
        'cashRabatt': cashRabatt.toString(),
        'naturalRabatt': naturalRabatt.toString(),
        'bewertung': bewertung.toString(),
        'comment': comment,
        'dueDate': dueDate,
        'status': status,
      });
      final extractedData = json.decode(response.body) as dynamic;
      _items.add(Project(
        id: extractedData['id'],
        name: name,
        customer: customer,
        medium: medium,
        brand: brand,
        agency: agency,
        mn3: mn3,
        cashRabatt: cashRabatt,
        naturalRabatt: naturalRabatt,
        bewertung: bewertung,
        comment: comment,
        dueDate: dueDate,
        status: status,
      ));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
