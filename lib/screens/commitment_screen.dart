import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/commitment_item.dart';
import '../providers/commitment_list.dart';
import '../widgets/commitment_side_item.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';
import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';
import '../widgets/year_select.dart';
import '../providers/year.dart';

class CommitmentScreen extends StatelessWidget {
  static const routeName = '/commitment';
  Verkaeufer selectedVerkaufer;
  String selectedYear;

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;
    selectedYear = Provider.of<Year>(context).selectedYear;
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    String pageType = (args != null && args.containsKey('pageType'))
        ? args['pageType']
        : null;
    String pageId =
        (args != null && args.containsKey('id')) ? args['id'] : null;
    String pageName =
        (args != null && args.containsKey('pageName')) ? args['pageName'] : null;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Commitment ${(pageName != null) ? ' -  ' + pageName : ''}'),
        actions: <Widget>[
          UserSelect(),
          SizedBox(
            width: 10,
          ),
          YearSelect(
            disable: true,
          ),
          SizedBox(
            width: 30,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: (Row(
          children: [
            FutureBuilder(
              future: Provider.of<CommitmentList>(context).fetchAndSetCommitmentList(
                init: true,
                verkaeufer: selectedVerkaufer,
                year: selectedYear,
                pageType: pageType,
                id: pageId,
              ),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 1650,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    // ...
                    // Do error handling stuff
                    print(dataSnapshot.error);
                    return Container(
                        width: 1650,
                        child: Center(
                          child: Text(
                              'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung...'),
                        ));
                  } else {
                    return Container(
                      width: 1650,
                      child: Consumer<CommitmentList>(
                        builder: (ctx, commitmentData, child) => Center(
                          child: CommitmentItem(
                            commitmentData,
                            pageType: pageType,
                            pageId: pageId,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            CommitmentSideItem(selectedVerkaufer),
          ],
        )),
      ),
    );
  }
}
