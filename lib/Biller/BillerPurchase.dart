import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/Biller/billerdashboard.dart';
import 'package:tradeapp/repository/Apifile.dart';
import 'package:http/http.dart' as http;

class BillerTradeApproval extends StatefulWidget {
  const BillerTradeApproval({super.key});

  @override
  State<BillerTradeApproval> createState() => _BillerTradeApprovalState();
}

class _BillerTradeApprovalState extends State<BillerTradeApproval> {
  List<Map<String, dynamic>> trades = [];
  

  @override
  void initState() {
    super.initState();
    fetchTradeHistory();
  } 

  fetchTradeHistory() async {
    print("API call start to fetch trade details");
    Map history = {};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String client = prefs.getString("ClientData") ?? "";
    print("getmethod:::::::::::$client");

    var clientDetails = jsonDecode(client);
    if (clientDetails["role"] == "client") {
      history = {"clientId": clientDetails["clientId"]};
    } else {
      history = {};
    }

    print(history);

    var response = await Apicall().tradehistory(history);

    if (response.isNotEmpty) {
      if (response["status"] == "S") {
        print("Trade execution response: $response");

        setState(() {
          trades = List<Map<String, dynamic>>.from(response["tradeMasterDetailsStructArr"]);
        });
      } else {
        print("Error: ${response["errMsg"]}");
      }
    } else {
      print("No response received");
    }
  }

  
  UpdateBillingStatus(int tradeId, String orderStatus) async {
    final Map<String, dynamic> payload = {
      'bo_status': orderStatus, 
      'trade_id': tradeId,     
    };

    try {
      var response = await Apicall().billingupdate(payload); 
     
     
        print("jdfhffhjghjfdg");
        print(response);
        if (response["status"] == "S") {
          return response;
        } else {
          return {'status': 'E', 'msg': 'Failed to update Biller status'};
        }
     
    } catch (e) {
      return {'status': 'E', 'msg': 'Error: $e'};
    }
  }

  // Trade approval logic
   approveTrade(int index) async {
    print("++++++++++++++++++++++++");
    setState(() {
      trades[index]["status"] = "Approved"; // Update local status
    });

    int tradeId = trades[index]["trade_id"];
    var response = await UpdateBillingStatus(tradeId, "Y"); // Update billing status to "Y" for approval
 print("++++++++++${response}++++++++++++++");
    if (response['status'] == 'S') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trade approved successfully!')));
      setState(() {
        trades[index]["order_status"] = "Approved"; // Update the UI with the approved status
      });
    } else {
       print("+++++++++^^^^^^^+++++++++++++++");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to approve the trade: ${response["msg"]}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: trades.length,
        itemBuilder: (BuildContext context, int index) {
          final trade = trades[index];
           if(trade["bo_status"]=='P'){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client ID: ${trade["client_id"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Trade ID: ${trade["trade_id"]}", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text("Stock Name: ${trade["stock_name"]}", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text("Stock Price: \$${trade["trade_price"]}", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text("Quantity: ${trade["quantity"]}", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text("Total Price: \$${trade["amount"]}", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Status: ",
                            style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: trade["bo_status"],
                            style: TextStyle(
                              fontSize: 14,
                              color: trade["status"] == "Approved" ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async{
                        await  approveTrade(index); 
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Billerdashboard(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          "Approve", 
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
         } else{
          return Container();
         }
         },
      ),
    );
  }
}
