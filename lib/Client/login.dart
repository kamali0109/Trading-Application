import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/Admin/admindashboard.dart';
import 'package:tradeapp/Client/alert.dart';
import 'package:tradeapp/Client/registration.dart';  
import 'package:tradeapp/repository/Apifile.dart';

import '../Biller/BillerPurchase.dart';
import '../Biller/billerdashboard.dart'; 

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _ClientController1 = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();

  
  onLoginMethod() async {
    var logindata = {
      "clientId": _ClientController1.text,
      "password": _passwordController2.text
    };

    try {
      var response = await Apicall().loginmethod(logindata);
      Map responseMap = response;

      if (response.isNotEmpty) {
        if (response["status"] == "S") {
     
          responsemethod(jsonEncode(response["clientMasterRec"]));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login Successful!"),
            backgroundColor: const Color.fromARGB(255, 0, 105, 54),duration: Duration(seconds: 2),
          ));

          String role = response["clientMasterRec"]["role"];
          if (role == "admin") {
           
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          } 
        else  if (role == "biller") {
           
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Billerdashboard()),
            );
          } 
          
          
          
          else {
           
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Alert()),
            );
          }
        } else {
       
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid credentials. Please try again."),
            backgroundColor: Colors.redAccent,
          ));
        }
      } else {
       
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login failed. No response from server."),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
    
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred. Please try again."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ));
    }
  }

  responsemethod(String clientData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ClientData", clientData);  
    print("Set method:::::::::::${prefs.getString('ClientData')}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x665ac18e), Color(0x995ac18e), Color(0xcc5ac18e), Color(0xff5ac18e)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  TextFormField(
                    controller: _ClientController1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the Client ID';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      label: Text('Client ID'),
                      hintText: 'Client ID',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  TextFormField(
                    obscureText: true,
                    obscuringCharacter: "*",
                    controller: _passwordController2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the Password';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      label: Text('Password'),
                      hintText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  ElevatedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        onLoginMethod();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 54, 112, 83),
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registration(),));
                    },
                    child: Text("Don't have an account? Sign up", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
