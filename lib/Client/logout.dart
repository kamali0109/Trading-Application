import 'package:flutter/material.dart';
import 'package:tradeapp/Client/Profile.dart';
import 'package:tradeapp/Client/dashboard.dart';
import 'package:tradeapp/Client/login.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Logout> {
   void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLogoutDialog(context);
    });
    super.initState();
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
        
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const login()),
                ); 
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
     
   Profile()
    );
  }
}
