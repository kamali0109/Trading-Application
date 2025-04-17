import 'package:flutter/material.dart';
import 'package:tradeapp/Admin/Bankmaster.dart';
import 'package:tradeapp/Admin/Billinggeneration.dart';
import 'package:tradeapp/Admin/Configcharges.dart';
import 'package:tradeapp/Admin/AdminPurchase.dart';
import 'package:tradeapp/Admin/Request.dart';
import 'package:tradeapp/Admin/Transaction.dart';
import 'package:tradeapp/Admin/Usermanagement.dart';
import 'package:tradeapp/Admin/logout.dart';
import 'package:tradeapp/Client/login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard> {
  late int selectedIndex;

  final List<String> headers = [
    "Dashboard",
    "Transaction",
    "Billing Generation",
    "Bank Master",
    "User Management",
    "Config Charges",
    "Logout"
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getBodyContent() {
    switch (selectedIndex) {
      case 0:
        return TabBarView(
          children: [
            ClientKycStatus(),
            AdminTradeApproval(),
          ],
        );
      case 1:
        return TransactionManagement();
      case 2:
        return Billinggeneration();
      case 3:
        return const BankMaster();
      case 4:
        return const UserManagement();
      case 5:
        return const ConfigManagement();
      case 6:
        return const Logout();
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
          title: Text((selectedIndex == 6) ? '' : headers[selectedIndex]),
          bottom: selectedIndex == 0
              ? const TabBar(
                  tabs: [
                    Tab(text: "Request"),
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
                leading: const Icon(Icons.history, color: Colors.teal),
                title: const Text("Bank Master", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setSelectedIndex(3);
                  Navigator.pop(context); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long, color: Colors.teal),
                title: const Text("User Management", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setSelectedIndex(4);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long, color: Colors.teal),
                title: const Text("Config Charges", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setSelectedIndex(5);
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
  print("inside dialog"); 
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
