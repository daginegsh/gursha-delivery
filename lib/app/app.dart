import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../themes/app_theme.dart';

class GurshaApp extends StatelessWidget {
  const GurshaApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "Gursha Delivery",

      theme: AppTheme.lightTheme,

      initialRoute: AppRoutes.routes.keys.first,

      routes: AppRoutes.routes,

    );

  }

}