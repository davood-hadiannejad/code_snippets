import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/signup_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/dashboard_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Visoon Forecasting',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(25, 89, 201, 1),
            accentColor: Color.fromRGBO(108, 208, 155, 1),
            fontFamily: 'Roboto',
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
          },
        ),
      ),
    );
  }
}
