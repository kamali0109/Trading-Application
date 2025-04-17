import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/Client/Billing.dart';
import 'package:tradeapp/Client/Profile.dart';
import 'package:tradeapp/Client/login.dart';
import 'package:tradeapp/Client/logout.dart';
import 'package:tradeapp/Client/tradeexecution.dart';
import 'package:tradeapp/Client/tradehistory.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  List<Widget> pages = [
    Profile(),
    Text('Dashboard'),
    TradeExecution(),
    Tradehistory(),
    Billing(),
    Logout(),
  ];

  List<String> headings = [
    'Profile',
    'Dashboard',
    'Trade Execution',
    'Trade History',
    'Billing',
    'Logout'
    
  ];

  int selectedIndex = 1;

  Map clientDetails = {};

  @override
  void initState() {
    super.initState();
    clientDataToControllers();
    fetchMethod();
    
  }

  fetchMethod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String clientData = prefs.getString("ClientData") ?? "";
  print("Fetched client data: $clientData");

  if (clientData.isNotEmpty) {
    setState(() {
      clientDetails = jsonDecode(clientData);
    });

   
    clientDataToControllers();
  } else {
    print("No client data found in SharedPreferences.");
  }
}

clientDataToControllers() {

  setState(() {
    firstNameController.text = clientDetails["first_name"] ?? "";
    emailController.text = clientDetails["email"] ?? "";
    phoneController.text = clientDetails["phone_number"] ?? "";
  });

 
  print("First Name: ${firstNameController.text}");
  print("Email: ${emailController.text}");
  print("Phone: ${phoneController.text}");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          headings[selectedIndex],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0x665ac18e),
        centerTitle: true,
      ),
      body: selectedIndex == 1
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.person,
                  color1: Colors.orange,
                  color2: Colors.deepOrangeAccent,
                  title: 'Profile',
                  subtitle: 'View your profile details.',
                  data:
                      'Name: ${firstNameController.text}\nEmail: ${emailController.text}\nPhone: ${phoneController.text}',
                  onTap: () {
                    setState(() {
                      selectedIndex =
                          0; 
                    });
                    // Navigator.of(context)
                    //     .pop(); 
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.trending_up,
                  color1: Colors.teal,
                  color2: Colors.tealAccent,
                  title: 'Trade Execution',
                  subtitle: 'Place new trades quickly.',
                  data: 'Active Trades: 5\nPending: 2',
                  onTap: () => setState(() => selectedIndex = 2),
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.history,
                  color1: Colors.green,
                  color2: Colors.lightGreen,
                  title: 'Trade History',
                  subtitle: 'View your recent trade activity.',
                  data: 'Last Trade: +500 USD\nTotal Trades: 150',
                  onTap: () => setState(() => selectedIndex = 3),
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.receipt_long,
                  color1: Colors.purple,
                  color2: Colors.deepPurpleAccent,
                  title: 'Billing',
                  subtitle: 'Check your billing details.',
                  data: 'Total Due: 250 USD\nLast Payment: 15-Nov-2024',
                  onTap: () => setState(() => selectedIndex = 4),
                ),
              ],
            )
          : pages[selectedIndex],
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required Color color1,
    required Color color2,
    required String title,
    required String subtitle,
    required String data,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
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
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () {
              setState(() {
                selectedIndex = 0;
                Navigator.pop(context);
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            onTap: () {
              setState(() {
                selectedIndex = 1;
                Navigator.pop(context);
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.trending_up,
            text: 'Trade Execution',
            onTap: () {
              setState(() {
                selectedIndex = 2;
                Navigator.pop(context);
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Trade History',
            onTap: () {
              setState(() {
                selectedIndex = 3;
                Navigator.pop(context);
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            text: 'Billing',
            onTap: () {
              setState(() {
                selectedIndex = 4;
                Navigator.pop(context);
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              setState(() {
                selectedIndex = 5;
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
