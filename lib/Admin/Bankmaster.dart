import 'package:flutter/material.dart';

class BankMaster extends StatefulWidget {
  const BankMaster({super.key});

  @override
  State<BankMaster> createState() => _BankMasterPageState();
}

class _BankMasterPageState extends State<BankMaster> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<Map<String, String>> _banks = [];

  final _formKey = GlobalKey<FormState>();
  int? _editIndex; 

  void _addOrUpdateBank() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      if (_editIndex == null) {
       
        _banks.add({
          "Bank Name": _bankNameController.text,
          "Branch Name": _branchNameController.text,
          "IFSC Code": _ifscController.text,
          "Address": _addressController.text,
        });
        _showMessage("Bank added successfully.");
      } else {
   
        _banks[_editIndex!] = {
          "Bank Name": _bankNameController.text,
          "Branch Name": _branchNameController.text,
          "IFSC Code": _ifscController.text,
          "Address": _addressController.text,
        };
        _showMessage("Bank updated successfully.");
        _editIndex = null; 
      }
      _clearFields();
    });
  }

  void _editBank(int index) {
    setState(() {
      _editIndex = index;
     
      _bankNameController.text = _banks[index]["Bank Name"]!;
      _branchNameController.text = _banks[index]["Branch Name"]!;
      _ifscController.text = _banks[index]["IFSC Code"]!;
      _addressController.text = _banks[index]["Address"]!;
    });
  }

  void _deleteBank(int index) {
    setState(() {
      _banks.removeAt(index);
    });
    _showMessage("Bank deleted successfully.");
  }

  void _clearFields() {
    _bankNameController.clear();
    _branchNameController.clear();
    _ifscController.clear();
    _addressController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _bankNameController,
                    decoration: const InputDecoration(
                      labelText: "Bank Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the bank name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _branchNameController,
                    decoration: const InputDecoration(
                      labelText: "Branch Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the branch name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ifscController,
                    decoration: const InputDecoration(
                      labelText: "IFSC Code",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the IFSC code' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the address' : null,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addOrUpdateBank,
                    child: Text(_editIndex == null ? 'Add Bank' : 'Update Bank'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _banks.isNotEmpty
                  ? ListView.builder(
                      itemCount: _banks.length,
                      itemBuilder: (context, index) {
                        final bank = _banks[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ListTile(
                            title: Text(bank["Bank Name"]!),
                            subtitle: Text(
                                "Branch: ${bank["Branch Name"]}\nIFSC: ${bank["IFSC Code"]}\nAddress: ${bank["Address"]}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editBank(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteBank(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No banks added yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
