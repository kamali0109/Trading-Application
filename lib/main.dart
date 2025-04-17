
import 'package:flutter/material.dart';
import 'package:tradeapp/Admin/admindashboard.dart';
import 'package:tradeapp/Client/Profile.dart';
import 'package:tradeapp/Client/dashboard.dart';
import 'package:tradeapp/Client/login.dart';
import 'package:tradeapp/Client/registration.dart';
import 'package:tradeapp/Client/request.dart';
import 'package:tradeapp/Client/tracking.dart';
import 'package:tradeapp/Client/tradeexecution.dart';
import 'package:tradeapp/Client/tradehistory.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: login(),

       


    );
  }
}
