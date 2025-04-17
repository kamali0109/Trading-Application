import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Billinggeneration extends StatefulWidget {
  const Billinggeneration({super.key});

  @override
  State<Billinggeneration> createState() => Billinggenerationpage();
}

class Billinggenerationpage extends State<Billinggeneration> {
 final _formKey = GlobalKey<FormState>();
  String? clientId;
  String tradeId = '';
  DateTime? tradeDate;
  String stockName = '';
  String quantity = '';
  String brokeragePercentage = '';
  String sttPercentage = '';
  String dematCharges = '';
  String totalCharges = '';

  List<String> clientList = [
    'Client 1',
    'Client 2',
    'Client 3'
  ]; 
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Bill Generation'),
          content: Text(
              'Are you sure you want to generate the bill for this trade?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _generateBill();
              },
            ),
          ],
        );
      },
    );
  }

  void _generateBill() {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Bill generated successfully!'),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildDropdownField('Client ID', clientId, clientList),
                      _buildTextField('Trade ID', tradeId, true),
                      _buildDatePicker(context),
                      _buildTextField('Stock Name', stockName, true),
                      _buildTextField('Quantity', quantity, true),
                      _buildTextField(
                          'Brokerage Percentage', brokeragePercentage, true),
                      _buildTextField('STT Percentage', sttPercentage, true),
                      _buildTextField('Demat Charges', dematCharges, true),
                      _buildTextField('Total Charges', totalCharges, true),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Generate Bill'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[300],
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: _showDialog,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, bool readOnly) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: readOnly ? Colors.grey[200] : Colors.white,
        ),
        readOnly: readOnly,
        initialValue: value,
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            clientId = newValue;
          });
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Trade Date',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        readOnly: true,
        controller: TextEditingController(
          text: tradeDate == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(tradeDate!),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(new FocusNode());
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: tradeDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2025),
          );
          if (picked != null && picked != tradeDate) {
            setState(() {
              tradeDate = picked;
            });
          }
        },
      ),
    );
  }
}