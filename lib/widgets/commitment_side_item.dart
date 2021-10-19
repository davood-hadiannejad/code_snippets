import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/commitment_list.dart';
import './select_menu.dart';
import './commitment_dialog.dart';
import '../providers/verkaeufer.dart';

class CommitmentSideItem extends StatefulWidget {
  final Verkaeufer selectedVerkaeufer;

  CommitmentSideItem(this.selectedVerkaeufer);
  @override
  _CommitmentSideItemState createState() =>
      _CommitmentSideItemState();
}

class _CommitmentSideItemState extends State<CommitmentSideItem> {
  String isSelected = 'offen';
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 2,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Center(
                child: RaisedButton.icon(
                  onPressed: widget.selectedVerkaeufer.isGroup ? null : ()  => commitmentDialog(context),
                  label: Text('Neues Commitment'),
                  icon: Icon(Icons.add),
                ),
              ),
              SizedBox(height: 60,),
              Text(
                'Suche & Filter',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextField(
                onChanged: (text) {
                  Provider.of<CommitmentList>(context, listen: false).searchByName(text);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Suche...',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: SelectMenu('commitment',[], 'Brand')),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'offen')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'offen';
                        Provider.of<CommitmentList>(context,
                            listen: false)
                            .filterByStatus('offen');
                      });
                    }
                  },
                  child: Text(
                    'offene Commitments',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Center(
                child: FlatButton(
                  minWidth: 200,
                  color: (isSelected == 'abgeschlossen')
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor.withOpacity(0.70),
                  textColor: Colors.white,
                  onPressed: () {
                    if (this.mounted) {
                      setState(() {
                        isSelected = 'abgeschlossen';
                        Provider.of<CommitmentList>(context,
                            listen: false)
                            .filterByStatus('abgeschlossen');
                      });
                    }
                  },
                  child: Text(
                    'abgeschlossene Commitments',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
