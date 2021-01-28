import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './providers/year.dart';
import './providers/agency_list.dart';
import './providers/aob_list.dart';
import './providers/brand_list.dart';
import './providers/customer_list.dart';
import './providers/verkaeufer_list.dart';
import './providers/detail.dart';
import './providers/project_list.dart';
import './providers/customer_forecast_list.dart';
import './providers/summary_list.dart';
import './screens/signup_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/dashboard_screen.dart';
import './screens/detail_screen.dart';
import './screens/project_forecast_screen.dart';
import './screens/customer_forecast_screen.dart';

String APIPROTOCOL = 'http://';
//String APIHOST = 'hammbwdsc02:96';
String APIHOST = 'salescontrolapi.visoon.de';

void main() => runApp(VisoonApp());

class VisoonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, SummaryList>(
          update: (ctx, auth, previousSummaryList) => SummaryList(
            auth.token,
            previousSummaryList == null ? [] : previousSummaryList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Detail>(
          update: (ctx, auth, previousDetail) => Detail(
            auth.token,
            previousDetail == null ? '' : previousDetail.name,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ProjectList>(
          update: (ctx, auth, previousProjectList) => ProjectList(
            auth.token,
            previousProjectList == null ? [] : previousProjectList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, CustomerForecastList>(
          update: (ctx, auth, previousCustomerForecastList) =>
              CustomerForecastList(
            auth.token,
            previousCustomerForecastList == null
                ? []
                : previousCustomerForecastList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, AOBList>(
          update: (ctx, auth, previousAOBList) => AOBList(
            auth.token,
            previousAOBList == null ? [] : previousAOBList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, VerkaeuferList>(
          update: (ctx, auth, previousVerkaeuferList) => VerkaeuferList(
            auth.token,
            previousVerkaeuferList == null ? [] : previousVerkaeuferList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, BrandList>(
          update: (ctx, auth, previousBrandList) => BrandList(
            auth.token,
            previousBrandList == null ? [] : previousBrandList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, CustomerList>(
          update: (ctx, auth, previousCustomerList) => CustomerList(
            auth.token,
            previousCustomerList == null ? [] : previousCustomerList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, AgencyList>(
          update: (ctx, auth, previousAgencyList) => AgencyList(
            auth.token,
            previousAgencyList == null ? [] : previousAgencyList.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Year>(
          update: (ctx, auth, previousYear) => Year(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Visoon Forecasting',
          theme: ThemeData(
            primaryColor: const Color(0xff1e1e1e),
            accentColor: const Color(0xffe20644),
            fontFamily: 'Futura',
          ),
          home: auth.isAuth
              ? DashboardScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : SignUpScreen(),
                ),
          routes: {
            DetailScreen.routeName: (ctx) => DetailScreen(),
            CustomerForecastScreen.routeName: (ctx) => CustomerForecastScreen(),
            ProjectForecastScreen.routeName: (ctx) => ProjectForecastScreen(),
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('de')
          ],
        ),
      ),
    );
  }
}
