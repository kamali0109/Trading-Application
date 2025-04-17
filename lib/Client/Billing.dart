import 'package:flutter/material.dart';

class Billing extends StatefulWidget {
  const Billing({super.key});

  @override
  State<Billing> createState() => BillingState();
}

class BillingState extends State<Billing> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController billingIdController = TextEditingController();
  TextEditingController tradeIdController = TextEditingController();
  TextEditingController brokerageController = TextEditingController();
  TextEditingController sttController = TextEditingController();
  TextEditingController dematChargesController = TextEditingController();
  TextEditingController totalChargesController = TextEditingController();
  TextEditingController billingDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Billing Information'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, 
          child: ListView(
             clipBehavior: Clip.none,
            children: [

         
              TextFormField(
                controller: billingIdController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.receipt_long,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'Billing ID',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Billing ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: tradeIdController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.trending_up,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'Trade ID',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Trade ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: brokerageController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'Brokerage',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Brokerage amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: sttController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.money,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'STT',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter STT amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

 
              TextFormField(
                controller: dematChargesController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance_wallet,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'Demat Charges',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Demat Charges';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: totalChargesController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calculate,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'Total Charges',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Total Charges';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

          
              TextFormField(
                controller: billingDateController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.date_range,color: Color(
                              (0x663F9C6E),
                            )),
                  labelText: 'Billing Date',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Billing Date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                     
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('PDF generation triggered!'),duration: Duration(seconds: 2),),
                      );
                    }
                  },
                  icon:  Icon(Icons.picture_as_pdf,color: Color(
                              (0x46E00909),
                            )),
                  label:  Text('Generate PDF',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(102, 21, 209, 115),
                    padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                    textStyle:  TextStyle(fontSize: 14), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
