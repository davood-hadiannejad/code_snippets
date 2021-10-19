import 'package:flutter/material.dart';

import './commitment_form.dart';

enum AddAction { CANCEL, ACCEPT }

Future<void> commitmentDialog(context, {commitmentId}) async {
  return showDialog<AddAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: (commitmentId != null) ? Text('Commitment bearbeiten') : Text('Neues Commitment hinzufügen'),
        content: CommitmentForm(commitmentId: commitmentId,),
      );
    },
  );
}