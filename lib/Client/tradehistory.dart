import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeapp/Client/tracking.dart';
import 'package:tradeapp/repository/Apifile.dart';

class Tradehistory extends StatefulWidget {
  const Tradehistory({super.key});

  @override
  State<Tradehistory> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Tradehistory> {
  List<Map<String, dynamic>> tradeHistory = [];
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchTradeHistory();
  }

  fetchTradeHistory() async {
    print("API call start to fetch trade details");
    Map history = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Client = prefs.getString("ClientData") ?? "";
    print("getmethod:::::::::::$Client");
    var clientDetails = jsonDecode(Client);
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
          tradeHistory = List<Map<String, dynamic>>.from(
              response["tradeMasterDetailsStructArr"]);
        });
      } else {
        print("Error: ${response["errMsg"]}");
      }
    } else {
      print("No response received");
    }
  }

  Tradedelete(int tradeId) async {
    if (tradeId.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Trade ID is missing."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ));
      return;
    }
    var body = ({"trade_id": tradeId});
    print("Request body for delete: $body");

    var response = await Apicall().tradedelete(body);

    if (response != null) {
      if (response["status"] == "S") {
        setState(() {
          tradeHistory.removeWhere((trade) => trade["trade_id"] == tradeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Trade deleted successfully."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${response["msg"] ?? "Unknown error"}"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete trade, try again."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: tradeHistory.length,
          itemBuilder: (context, index) {
            final trade = tradeHistory[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      trade["stock_name"] ?? "N/A",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ISIN: ${trade["isin"] ?? "N/A"}"),
                        Text("Price: ${trade["trade_price"] ?? "N/A"}"),
                        IconButton(
                          onPressed: () {
                            print(
                                "Deleting trade with ID: ${trade["trade_id"]}");
                            Tradedelete(trade["trade_id"]);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        expandedIndex == index
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Color(0x663F9C6E),
                      ),
                      onPressed: () {
                        setState(() {
                          expandedIndex = expandedIndex == index ? null : index;
                        });
                      },
                    ),
                  ),
                  if (expandedIndex == index)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StepperWidget(
                        onStepperComplete: () {
                          setState(() {
                            expandedIndex = null;
                          });
                        },
                        trade: trade,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class StepperWidget extends StatefulWidget {
  final VoidCallback onStepperComplete;
  final Map<String, dynamic> trade;

  const StepperWidget({
    required this.onStepperComplete,
    required this.trade,
    super.key,
  });

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  int currentStep = 0;

 
  Color getStepColor(String status) {
    if (status == "Y") {
      return Colors.green; 
    } else if (status == "P") {
      return Colors.red; 
    } else {
      return Colors.grey; 
    }
  }

 
  List<Step> get steps {
    List<Step> steps = [];

    // Step 1: Order Placed
    steps.add(Step(
      title: Container(
        color: getStepColor(widget.trade["order_status"] ?? ""),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Order Placed'),
        ),
      ),
      content: Text(widget.trade["trade_date"] ?? "N/A"),
      isActive: true,
    ));

    // Step 2: Pending (Admin status)
    steps.add(Step(
      title: Container(
        color: getStepColor(widget.trade["admin_status"] ?? ""),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Pending'),
        ),
      ),
      content: Text(widget.trade["trade_date"] ?? "N/A"),
      isActive: true,
    ));

    steps.add(Step(
      title: Container(
        color: getStepColor(widget.trade["bo_status"] ?? ""),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Completed'),
        ),
      ),
      content: Text(widget.trade["trade_date"] ?? "N/A"),
      isActive: true,
    ));

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Theme(
        data: ThemeData(
          primaryColor: Color(0x665ac18e), 
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Color(0x665ac18e),
                secondary: Color(0x665ac18e),
              ),
        ),
        child: Stepper(
          currentStep: currentStep,
          steps: steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              currentStep = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (currentStep < steps.length - 1) {
                currentStep += 1;
              } else {
                widget.onStepperComplete();
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep -= 1;
              }
            });
          },
        ),
      ),
    );
  }
}
