import 'package:bus_karo/screens/authentication.dart';
import 'package:bus_karo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'injections/dependency_injection.dart';


Future<void> main() async{
  runApp(MyApp());
  DependencyInjection.init();
}



class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool isUserAuthenticated = false;                                  //  Dynamically derive its value using AWS cognito

  void changeUserAuthenticationStatus({required bool change})
  {
    isUserAuthenticated = change;
  }

  @override
  Widget build(BuildContext context) {

    Widget initialScreen = const HomeScreen();

    if(!isUserAuthenticated) initialScreen = AuthenticationScreen(changeUserAuthenticationStatus: changeUserAuthenticationStatus,);
    // comment line 31 to bypass login/signup screen.

    return GetMaterialApp(
      title: 'Bus Karo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}




