import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/detail.dart';
import './providers/summary_list.dart';
import './screens/signup_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/dashboard_screen.dart';
import './screens/booking_screen.dart';
import './screens/detail_screen.dart';
import './screens/project_forecast_screen.dart';

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
            BookingScreen.routeName: (ctx) => BookingScreen(),
            DetailScreen.routeName: (ctx) => DetailScreen(),
            ProjectForecastScreen.routeName: (ctx) => ProjectForecastScreen(),
          },
        ),
      ),
    );
  }
}
