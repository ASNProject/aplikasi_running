import 'package:aplikasi_running/cores/routers/app_route_configuration.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser:
          AppRouterConfiguration.returnRouter(false).routeInformationParser,
      routerDelegate: AppRouterConfiguration.returnRouter(false).routerDelegate,
    );
  }
}
