import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/customer/home_screen.dart';
import '../screens/splash/splash_screen.dart' as splash;

class AppRoutes{
  static const splashRoute="/";

  static const login="/login";

  static const register="/register";

  static const home="/home";

  static Map<String,WidgetBuilder> routes={

    splashRoute:(context)=>const splash.SplashScreen(),

    login:(context)=>const LoginScreen(),

    register:(context)=>const RegisterScreen(),

    home:(context)=>const HomeScreen(),

  };

}