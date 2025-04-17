import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/Client/dashboard.dart';
import 'package:tradeapp/Client/login.dart';
import 'package:tradeapp/repository/Apifile.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Request> {
 @override
  void initState() {
    getclientid();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSimpleDialog(context);
    });
    super.initState();
  }
    Map clientDetails = {};
 getclientid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Client = prefs.getString("responseMap") ?? "";
    print("getmethod:::::::::::$Client");
    clientDetails = jsonDecode(Client);
  
 }
  kycputmethod(String status) async {
    var kycdata = [{
      "client_id":clientDetails['clientId'],
       "kyc_status":status
    }];
    print("clientid::::::$kycdata");
    var response = await Apicall().kycputmethod(kycdata);
  
    if (response.isNotEmpty) {
      if (response["status"] == "S") {
       print("response::::::$response");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login not successfully,Try again"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ));
    }
  }
  

  void _showSimpleDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Please Activate the Client",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.all(20),
          children: [
            SimpleDialogOption(
              onPressed: () {
                kycputmethod('P') ;
               Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ));
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Send Request",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => login(),
                ));
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return  Scaffold(

    ) ;
  }
}