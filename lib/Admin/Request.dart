import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tradeapp/repository/Apifile.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class ClientKycStatus extends StatefulWidget {
  const ClientKycStatus({super.key});

  @override
  State<ClientKycStatus> createState() => _ClientKycStatusState();
}

class _ClientKycStatusState extends State<ClientKycStatus> {
  List<Map<String, dynamic>> clients = [];

  @override
  void initState() {
    super.initState();
    _fetchClientDetails();
  }

  _fetchClientDetails() async {
    var response = await Apicall().requestclientdetails(); 
    print(response);

    if (response != null && response['clientMasterArr'] != null) {
      setState(() {
        clients = (response['clientMasterArr'] as List).where((client) {
          return client['kyc_status'] == 'P';  
        }).map((client) {
          return {
            'clientId': client['clientId'],
            'email': client['email'],
            'phone': client['phone_number'],
            'panCard': client['pan_card'],
            'kycStatus': _mapKycStatus(client['kyc_status']),
            'isSelected': false, 
          };
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load client data")),
      );
    }
  }

  String _mapKycStatus(String kycStatus) {
    if (kycStatus == 'P') {
      return 'Pending';
    } else if (kycStatus == 'Y') {
      return 'Active';
    }
    return 'Unknown';
  }

  void activateSelectedClients() async {
    List<Map<String, dynamic>> clientsToActivate = [];
    
    for (var client in clients) {
      if (client["isSelected"]) {
        client["kycStatus"] = "Y";  
        clientsToActivate.add({
          "client_id": client["clientId"],
          "kyc_status": "Y",
        });
      }
    }

    if (clientsToActivate.isNotEmpty) {
      var response = await Apicall().kycputmethod(clientsToActivate);
      if (response != null && response['status'] == 'S') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("KYC Status updated successfully"),
          backgroundColor: Colors.green,
        ));
        setState(() {
          _fetchClientDetails(); 
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update KYC status"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void toggleCheckbox(int index) {
    setState(() {
      clients[index]["isSelected"] = !clients[index]["isSelected"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: clients.isEmpty
                ? Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (BuildContext context, int index) {
                      final client = clients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Client ID: ${client["clientId"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text("Email: ${client["email"]}",
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 8),
                                    Text("Phone: ${client["phone"]}",
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 8),
                                    Text("PAN Card: ${client["panCard"]}",
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 8),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "KYC Status: ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                            text: client["kycStatus"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: client["kycStatus"] == "Y"
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 1.25,
                                  child: Checkbox(
                                    value: client["isSelected"],
                                    onChanged: (bool? value) {
                                      toggleCheckbox(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (clients.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: activateSelectedClients,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Activate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
