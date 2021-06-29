import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/detail_item.dart';
import '../widgets/mandant_brand_item.dart';
import '../providers/detail.dart';
import '../providers/verkaeufer.dart';
import '../providers/verkaeufer_list.dart';
import '../widgets/detail_filter.dart';
import '../widgets/user_select.dart';
import '../providers/auth.dart';
import '../widgets/main_drawer.dart';
import '../providers/year.dart';
import '../widgets/year_select.dart';

final tabList = ['Brandansicht', 'Goal und Forecast', 'Detailansicht'];

class DetailScreen extends StatefulWidget {
  static const routeName = '/detail';

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Verkaeufer selectedVerkaufer;
  String selectedYear;

  @override
  void initState() {
    Provider.of<Detail>(context, listen: false).resetFilter();
    super.initState();
  }

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
    selectedYear = Provider.of<Year>(context).selectedYear;
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
              SizedBox(width: 10,),
              YearSelect(),
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
                      init: true, verkaeufer: selectedVerkaufer, year: selectedYear),
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
                    return Row(
                      children: [
                        Container(
                          width: 1650,
                          child: Consumer<Detail>(
                            builder: (ctx, detailData, child) => Row(
                              children: [
                                Container(
                                  width: 1400,
                                  child: Center(
                                    child: (args['pageType'] == 'Mandant' ||
                                            args['pageType'] == 'Brand')
                                        ? MandantBrandItem(
                                            detailData, args['pageType'])
                                        : DetailItem(
                                            detailData, args['pageType']),
                                  ),
                                ),
                                DetailFilter(
                                  args['pageType'],
                                  args['id'],
                                  selectedVerkaufer,
                                  selectedYear,
                                  brandList: (detailData.brands != null)
                                      ? detailData.brands
                                          .map((e) => e['name'].toString())
                                          .toList()
                                      : null,
                                  mandantList: (detailData.brands != null && args['pageType'] != 'Mandant')
                                      ? detailData.brands
                                      .map((e) => e['mandant'].toString()).toSet()
                                      .toList()
                                      : null,
                                  customerList: (detailData.customers != null)
                                      ? detailData.customers
                                          .map((e) => e['name'].toString())
                                          .toList()
                                      : null,
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
