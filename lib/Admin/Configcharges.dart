import 'package:flutter/material.dart';



class ConfigManagement extends StatefulWidget {
  const ConfigManagement({super.key});

  @override
  State<ConfigManagement> createState() => _ConfigManagementState();
}

class _ConfigManagementState extends State<ConfigManagement> {
  String? selectedCharge;
  String chargePercentage = '';
  String effectiveDate = '';
  final List<String> chargeTypes = ['STT', 'Brokerage', 'Demat'];
  final List<Map<String, dynamic>> chargesList = [];
  Map<String, dynamic>? editingCharge;

  final _formKey = GlobalKey<FormState>();

  void addOrUpdateCharge() {
    if (!_formKey.currentState!.validate()) return;

    final chargeData = {
      'charge_type': selectedCharge,
      'charge_percentage': double.tryParse(chargePercentage),
      'effective_date': effectiveDate,
    };

    if (editingCharge != null) {
     
      setState(() {
        final index = chargesList.indexOf(editingCharge!);
        chargesList[index] = chargeData;
        editingCharge = null;
      });
    } else {
     
      setState(() {
        chargesList.add(chargeData);
      });
    }

    clearForm();
  }

  void clearForm() {
    setState(() {
      selectedCharge = null;
      chargePercentage = '';
      effectiveDate = '';
      editingCharge = null;
    });
  }

  void editCharge(Map<String, dynamic> charge) {
    setState(() {
      editingCharge = charge;
      selectedCharge = charge['charge_type'];
      chargePercentage = charge['charge_percentage'].toString();
      effectiveDate = charge['effective_date'];
    });
  }

  void deleteCharge(Map<String, dynamic> charge) {
    setState(() {
      chargesList.remove(charge);
    });
  }

  void resetTable() {
    setState(() {
      chargesList.clear();
      selectedCharge = null;
      chargePercentage = '';
      effectiveDate = '';
    });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCharge,
                    decoration: const InputDecoration(
                      labelText: 'Charge Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.list),
                    ),
                    items: chargeTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCharge = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a charge type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Charge Percentage',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.percent),
                    ),
                    onChanged: (value) {
                      chargePercentage = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a percentage' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Effective Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onChanged: (value) {
                      effectiveDate = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a date' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: addOrUpdateCharge,
                    child: Text(
                        editingCharge == null ? 'Add Charge' : 'Update Charge'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: chargesList.isEmpty
                  ? const Center(
                      child: Text(
                        'No charges added yet!',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: chargesList.length,
                      itemBuilder: (context, index) {
                        final charge = chargesList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              charge['charge_type'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'Percentage: ${charge['charge_percentage']}%\nEffective Date: ${charge['effective_date']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => editCharge(charge),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => deleteCharge(charge),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resetTable,
        child: const Icon(Icons.refresh),
        tooltip: 'Reset Charges',
      ),
    );
  }
}