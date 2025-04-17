import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/repository/Apifile.dart';

class TradeExecution extends StatefulWidget {
  const TradeExecution({super.key});

  @override
  State<TradeExecution> createState() => _MyWidgetState();
}


class _MyWidgetState extends State<TradeExecution> {
  Map<String, dynamic> tradeExecutionDetails = {};
  int selectedQuantity = 0;
  double amountPayable = 0;
  late Map<String, dynamic> selectedStock;

  // Show modal bottom sheet to capture order details
  void _showModalBottomSheet(BuildContext context, Map<String, dynamic> stock) {
    final TextEditingController quantityController = TextEditingController();

    quantityController.text = '0';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 350,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0x665ac18e),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stock Name: ${stock["stock_name"]}"),
                  Text("ISIN: ${stock["isin"]}"),
                  Text("Unit Price: ${stock["price"]}"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final quantity = int.tryParse(value);
                        if (quantity != null && quantity > 0) {
                          setState(() {
                            selectedQuantity = quantity;
                            amountPayable = quantity *
                                double.parse(stock["price"].toString());
                          });
                        } else {
                          setState(() {
                            selectedQuantity = 0;
                            amountPayable = 0;
                          });
                        }
                      } else {
                        setState(() {
                          selectedQuantity = 0;
                          amountPayable = 0;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Amount Payable: $amountPayable',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ElevatedButton(
  onPressed: selectedQuantity > 0
      ? () {
          // Insert the trade details when the order is placed
          _tradeInsert(stock);

          // Show the SnackBar to indicate successful order placement
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Order Placed Successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Wait for 3 seconds (to give the user time to see the SnackBar)
          Future.delayed(const Duration(seconds: 1), () {
            // Refresh trade execution details after placing the order
            fetchTradeDetails();  // Refresh the trade execution details

            // Pop the modal bottom sheet and go back to the TradeExecution page
            Navigator.pop(context); // Close the bottom sheet

            // Alternatively, if you want to navigate to the same page and reset state:
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const TradeExecution(),
            //   ),
            // );
          });
        }
      : null,  
  child: const Text('Place Order'),
),

                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Function to call trade insertion API
  _tradeInsert(Map<String, dynamic> stock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Client = prefs.getString("ClientData") ?? "";
    print("getmethod:::::::::::$Client");
     var clientDetails = jsonDecode(Client);
     print(clientDetails["clientId"]);
    var tradeData = {
      "quantity": selectedQuantity.toString(),
      "isin": stock["isin"],
      "tradePrice": stock["price"].toString(),
      "amount": amountPayable.toString(),
      "tradeType": "BUY",
      "clientId": clientDetails["clientId"],  
    };

    print("API call start to insert trade data");
    var response = await Apicall().tradeinsert(tradeData);

    if (response.isNotEmpty) {
      if (response["status"] == "S") {
        print("Trade execution response: $response");
        setState(() {
          tradeExecutionDetails = response;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${response['msg']}"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTradeDetails();
  }

  // Fetching trade execution details
  fetchTradeDetails() async {
    print("API call start to fetch trade details");
    var response = await Apicall().tradeexecution();

    if (response.isNotEmpty) {
      if (response["status"] == "S") {
        print("Trade execution response: $response");
        setState(() {
          tradeExecutionDetails = response;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Login not successful, Try again"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.builder(
          itemCount:
              tradeExecutionDetails['scriptMasterDetailsArr']?.length ?? 0,
          itemBuilder: (context, index) {
            final stock =
                tradeExecutionDetails['scriptMasterDetailsArr'][index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stock Name: ${stock["stock_name"]}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("ISIN: ${stock["isin"]}"),
                          Text("Price: ${stock["price"]}"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        selectedStock = stock; // Store selected stock details
                        _showModalBottomSheet(context, stock);
                      },
                      child: const Text('Buy'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
