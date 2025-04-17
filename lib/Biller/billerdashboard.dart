import 'package:flutter/material.dart';
import 'package:tradeapp/Admin/Bankmaster.dart';
import 'package:tradeapp/Admin/Billinggeneration.dart';
import 'package:tradeapp/Admin/Configcharges.dart';
import 'package:tradeapp/Admin/AdminPurchase.dart';
import 'package:tradeapp/Admin/Request.dart';
import 'package:tradeapp/Admin/Transaction.dart';
import 'package:tradeapp/Admin/Usermanagement.dart';
import 'package:tradeapp/Admin/logout.dart';
import 'package:tradeapp/Biller/BillerPurchase.dart';
import 'package:tradeapp/Client/login.dart';


class Billerdashboard extends StatefulWidget {
  const Billerdashboard({super.key});

  @override
  State<Billerdashboard> createState() => Billerdashboardstate();
}

class Billerdashboardstate extends State<Billerdashboard> {
  late int selectedIndex;

  // List of headers for navigation
  final List<String> headers = [
    "Biller Dashboard",
    "Transaction",
    "Billing Generation",
    "Logout"
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  // Set selected index for navigation
  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Get content based on the selected index
  Widget getBodyContent() {
    switch (selectedIndex) {
      case 0:
        return TabBarView(
          children: [
             
            BillerTradeApproval(), 
          ],
        );
      case 1:
        return TransactionManagement();  // Assuming TransactionManagement() is a page
      case 2:
        return Billinggeneration();  // Assuming Billinggeneration() is a page
      case 3:
        return const Logout();  // Assuming Logout() is a page
      default:
        return Center(
          child: Text(
            "This is the ${headers[selectedIndex]} Page",
            style: const TextStyle(fontSize: 24),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0x665ac18e),
          centerTitle: true,
          title: Text(
            selectedIndex == 0 ? headers[selectedIndex] : headers[selectedIndex],
          ),
          bottom: selectedIndex == 0
              ? const TabBar(
                  tabs: [
                    Tab(text: "Purchase"),
                  ],
                )
              : null,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.teal),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.teal),
                title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setSelectedIndex(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.teal),
                title: const Text("Transaction", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setSelectedIndex(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.teal),
                title: const Text("Billing Generation", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setSelectedIndex(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.teal),
                title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
        body: getBodyContent(),
      ),
    );
  }
}


void _showLogoutDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
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
