import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/Client/dashboard.dart';
import 'package:tradeapp/Client/login.dart';
import 'package:tradeapp/repository/Apifile.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  String clientId = '';
  String kycStatus = '';

  @override
  void initState() {
    super.initState();
    getClientData();
  }


  Future<void> getClientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString("ClientData");

    if (storedData != null) {
      Map<String, dynamic> clientData = jsonDecode(storedData);
      setState(() {
        clientId = clientData['clientId'];
        kycStatus = clientData['kyc_status'];
      });

      print("ClientId: $clientId");
      print("KYC Status: $kycStatus");

    
      _showMyDialog();
    } else {
      print("No Data found ");
    }
  }

  
  void _showMyDialog() {
    if (kycStatus == "N") {
      _showClientActivationDialog();
    } else if (kycStatus == "P") {
      _showKycPendingDialog();
    } else if (kycStatus == "Y" || kycStatus == "S") {
      _navigateToDashboard();
    }
  }


  void _showClientActivationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Client Activation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please Activate the Client!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Send Request'),
              onPressed: () async {
                if (clientId.isNotEmpty) {
                  await _updateKycStatus();
                } else {
                  _showSnackBar('Client ID not found!');
                }
              },
            ),
          ],
        );
      },
    );
  }


  void _showKycPendingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('KYC Pending'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your KYC is currently pending.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const login()),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _updateKycStatus() async {
    List<Map<String, dynamic>> kycData = [
      {"kyc_status": "P", "client_id": clientId}
    ];

    var response = await Apicall().kycputmethod(kycData);

    if (response != null && response['status'] == 'S') {
      _showSnackBar('KYC Status Updated ');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
    } else {
      _showSnackBar('Failed to update KYC status');
    }
  }

  
  void _navigateToDashboard() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    });
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),backgroundColor: Colors.lightBlue,duration: Duration(seconds: 2 ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(''), 
      ),
    );
  }
}
