import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/mandant_brand_item.dart';
import '../providers/detail.dart';
import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';
import '../widgets/detail_filter.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';

final tabList = ['Goal und Forecast', 'Detailansicht'];

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';
  Verkaeufer selectedVerkaufer;

  void gotoDashboard(BuildContext context) async {
    await Navigator.of(context).pushReplacementNamed('/');
  }

  void loadDashboard(BuildContext context) {
    Future.microtask(() {
      gotoDashboard(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedVerkaufer = Provider.of<VerkaeuferList>(context).selectedVerkaufer;

    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    if (args == null) {
      loadDashboard(context);
    } else {
      return DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          drawer: MainDrawer(),
          appBar: AppBar(
            bottom: buildTabBar(args),
            title: Text('Detailansicht'),
            actions: <Widget>[
              UserSelect(),
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
            child: FutureBuilder(
              future: Provider.of<Detail>(context, listen: false)
                  .fetchAndSetDetail(args['pageType'], args['id'],
                      init: true, verkaeufer: selectedVerkaufer),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 1500,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    // ...
                    // Do error handling stuff
                    print(dataSnapshot.error);
                    return Container(
                        width: 1500,
                        child: Center(
                          child: Text(
                              'Es ist ein Fehler aufgetreten! Bitte überprüfe deine Netzwerkverbidung...'),
                        ));
                  } else {
                    return Row(
                      children: [
                        Container(
                          width: 1500,
                          child: Consumer<Detail>(
                            builder: (ctx, detailData, child) => Row(
                              children: [
                                Container(
                                  width: 1250,
                                  child: Center(
                                    child: MandantBrandItem(detailData, args['pageType']),
                                  ),
                                ),
                                DetailFilter(
                                  args['pageType'],
                                  args['id'],
                                  selectedVerkaufer,
                                  brandList: (detailData.brands != null) ? detailData.brands
                                      .map((e) => e['name'].toString())
                                      .toList() : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ),
      );
    }
  }

  TabBar buildTabBar(args) {
    var pageType;
    if (args == null) {
      return null;
    } else {
      pageType = args['pageType'];
    }

    switch (pageType) {
      case "Kunde":
        {
          return TabBar(
            onTap: (selectedTab) {
              //Provider.of<SummaryList>(context, listen: false).fetchAndSetSummaryList(tabList[selectedTab]);
            },
            tabs: tabList
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          );
        }
        break;

      case "Agentur":
        {
          return TabBar(
            onTap: (selectedTab) {
              //Provider.of<SummaryList>(context, listen: false).fetchAndSetSummaryList(tabList[selectedTab]);
            },
            tabs: tabList
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          );
        }
        break;

      case "Konzern":
        {
          return TabBar(
            onTap: (selectedTab) {
              //Provider.of<SummaryList>(context, listen: false).fetchAndSetSummaryList(tabList[selectedTab]);
            },
            tabs: tabList
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          );
        }
        break;

      case "Agenturnetzwerk":
        {
          return TabBar(
            onTap: (selectedTab) {
              //Provider.of<SummaryList>(context, listen: false).fetchAndSetSummaryList(tabList[selectedTab]);
            },
            tabs: tabList
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          );
        }
        break;

      default:
        {
          return null;
        }
        break;
    }
  }
}
