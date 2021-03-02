import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verkaeufer_list.dart';
import '../providers/verkaeufer.dart';

class UserSelect extends StatefulWidget {
  UserSelect({Key key}) : super(key: key);

  @override
  _UserSelectState createState() => _UserSelectState();
}

class _UserSelectState extends State<UserSelect> {
  List<Verkaeufer> verkaeuferList;
  Verkaeufer selectedVerkaufer;

  @override
  void initState() {
    if (Provider.of<VerkaeuferList>(context, listen: false).items.isEmpty) {
      Provider.of<VerkaeuferList>(context, listen: false).fetchAndSetVerkaeuferList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    verkaeuferList = Provider.of<VerkaeuferList>(context).items;
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    return DropdownButton<String>(
      value: (selectedVerkaufer != null && selectedVerkaufer.email != null) ? selectedVerkaufer.email : 'Gesamt',
      //icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          .merge(TextStyle(color: Colors.white)),
      dropdownColor: Theme.of(context).accentColor,
      underline: Container(
        height: 1,
        color: Theme.of(context).accentColor,
      ),
      onChanged: (String email) {
        if (email != 'Gesamt') {
          Provider.of<VerkaeuferList>(context, listen: false).selectVerkaeuferByEmail(email);
        } else {
          Provider.of<VerkaeuferList>(context, listen: false).selectVerkaeuferByName('Gesamt');
        }

      },
      items: verkaeuferList.map<DropdownMenuItem<String>>((Verkaeufer verkaeufer) {
        return DropdownMenuItem<String>(
          value: (verkaeufer.name != 'Gesamt') ? verkaeufer.email : 'Gesamt',
          child: Text(verkaeufer.name),
        );
      }).toList(),
    );
  }
}
