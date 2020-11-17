import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './project_forecast_form.dart';
import '../providers/project_list.dart';

enum AddAction { CANCEL, ACCEPT }

Future<void> projectForecastDialog(context, {projectId}) async {
  return showDialog<AddAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: (projectId != null) ? Text('Projekt bearbeiten') : Text('Neues Projekt hinzufügen'),
        content: ProjectForecastForm(projectId: projectId,),
      );
    },
  );
}