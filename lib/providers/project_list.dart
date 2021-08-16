import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import './verkaeufer.dart';
import './project.dart';

String dummyData =
    '[{"id": 1, "name" : "Weinachtsproject", "customer": "Volkswagen", "medium": "TV", "brand": "Nick", "agency": "Initiative", "mn3": 500000, "cashRabatt": 10, "naturalRabatt": 5, "bewertung": 75, "comment": "", "status": "offen", "dueDate": "2020-11-30"}, '
    '{"id": 2, "name" : "Neu Jahrs Projekt", "customer": "Volkswagen", "medium": "TV", "brand": "Nick", "agency": "Initiative", "mn3": 600000, "cashRabatt": 5, "naturalRabatt": 5, "bewertung": 50, "comment": "das wird super toll!", "status": "offen", "dueDate": "2020-12-30"}, '
    '{"id": 3, "name" : "Fenbruar Projekt", "customer": "Volkswagen", "medium": "TV", "brand": "Nick", "agency": "Initiative", "mn3": 800000, "cashRabatt": 11, "naturalRabatt": 1, "bewertung": 100, "comment": "das wird super toll!das wird super toll! das wird super toll! das wird super toll! das wird super toll!das wird super toll! das wird super toll!", "status": "offen", "dueDate": "2021-02-30"}]';

class ProjectList with ChangeNotifier {
  List<Project> _items = [];
  List<Project> _activeItems = [];
  String statusFilter = 'offen';
  String searchString = '';
  List<String> filterBrandList = [];

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

  Future<void> searchByName(String currentSearchString) async {
    searchString = currentSearchString;
    notifyListeners();
  }

  Future<void> filterByStatus(String status) async {
    statusFilter = status;
    notifyListeners();
  }

  Future<void> filterByBrandList(List<String> currentFilterBrandList) async {
    filterBrandList = currentFilterBrandList;
    notifyListeners();
  }

  Future<void> fetchAndSetProjectList(
      {bool init = false, Verkaeufer verkaeufer, String year, String pageType, String id,}) async {
    Map<String, String> uriQuery = {};

    if (verkaeufer != null && verkaeufer.email != null) {
      uriQuery['email'] = verkaeufer.email;
    }

    if (year != null) {
      uriQuery['jahr'] = year;
    }

    if (pageType != null && id != null) {
      uriQuery[pageType.toLowerCase()] = id;
    }

    var uri = Uri.http(APIHOST, '/api/projects/', uriQuery);
    print(uri);
    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $authToken"},
      );
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      List<Project> loadedProjectList = [];
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
            monthlyMn3: {'m1': project['m1'], 'm2': project['m2'],
              'm3': project['m3'], 'm4': project['m4'], 'm5': project['m5'],
              'm6': project['m6'], 'm7': project['m7'], 'm8': project['m8'],
              'm9': project['m9'], 'm10': project['m10'], 'm11': project['m11'],
              'm12': project['m12'],},
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

      if (searchString != '') {
        loadedProjectList = loadedProjectList
            .where((project) => project.name
                .toLowerCase()
                .startsWith(searchString.toLowerCase()))
            .toList();
      }
      if (filterBrandList.isNotEmpty) {
        loadedProjectList = loadedProjectList
            .where((project) => filterBrandList.contains(project.brand))
            .toList();
      }

      _activeItems = loadedProjectList
          .where((project) => project.status == statusFilter)
          .toList();

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
    String verkaueferEmail,
    Map<String, double> monthlyMn3,
    double cashRabatt,
    double naturalRabatt,
    int bewertung,
    String comment,
    String dueDate,
    String status,
  ) async {
    var url = APIPROTOCOL + APIHOST + '/api/projects/';
    try {
      Map<String, dynamic> body = {
        'name': name,
        'kunde': customer,
        'verkaeufer': verkaueferEmail,
        'medium': medium,
        'brand': brand,
        'agentur': agency,
        'cashRabatt': cashRabatt.toString(),
        'naturalRabatt': naturalRabatt.toString(),
        'bewertung': bewertung.toString(),
        'comment': comment,
        'dueDate': dueDate,
        'status': status,
      };

      monthlyMn3.map((key, value) {
        body[key] = value;
        return;
      });

      final response = await http.post(url, headers: {
        "Authorization": "Bearer $authToken"
      }, body: body);
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as dynamic;
      _items.add(Project(
        id: extractedData['id'],
        name: name,
        customer: customer,
        medium: medium,
        brand: brand,
        agency: agency,
        monthlyMn3: monthlyMn3,
        mn3: extractedData['mn3'],
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

  Future<void> updateProject(
    int id,
    String name,
    String customer,
    String medium,
    String brand,
    String agency,
    String verkaueferEmail,
    Map<String, double> monthlyMn3,
    double cashRabatt,
    double naturalRabatt,
    int bewertung,
    String comment,
    String dueDate,
    String status,
    String year,
  ) async {
    var url = APIPROTOCOL + APIHOST + '/api/projects/${id.toString()}/?jahr=$year';
    try {
      Map<String, dynamic> body = {
        'id': id.toString(),
        'name': name,
        'kunde': customer,
        'verkaeufer': verkaueferEmail,
        'medium': medium,
        'brand': brand,
        'agentur': agency,
        'cashRabatt': cashRabatt.toString(),
        'naturalRabatt': naturalRabatt.toString(),
        'bewertung': bewertung.toString(),
        'comment': comment,
        'dueDate': dueDate,
        'status': status,
      };

      monthlyMn3.map((key, value) {
        body[key] = value;
        return;
      });

      final response = await http.put(url, headers: {
        "Authorization": "Bearer $authToken"
      }, body: body);
      final extractedData =
          json.decode(utf8.decode(response.bodyBytes)) as dynamic;
      _items.removeWhere((project) => project.id == id);
      print(url);
      _items.add(Project(
        id: extractedData['id'],
        name: name,
        customer: customer,
        medium: medium,
        brand: brand,
        agency: agency,
        mn3: extractedData['mn3'],
        monthlyMn3: monthlyMn3,
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
