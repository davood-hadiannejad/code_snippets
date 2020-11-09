import 'package:flutter/material.dart';

import './project_forecast_form.dart';

enum AddAction { CANCEL, ACCEPT }

Future<void> projectForecastDialog(context, {projectId}) async {
  return showDialog<AddAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: (projectId != null) ? Text('Projekt bearbeiten') : Text('Neues Projekt hinzufügen'),
        content: ProjectForecastForm(projectId: projectId,),
        actions: <Widget>[
          FlatButton(
            child: const Text('Abbrechen'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            child: const Text('Speichern'),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Theme.of(context).primaryColor,
          )
        ],
      );
    },
  );
}