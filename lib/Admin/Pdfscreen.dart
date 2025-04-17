import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PDFGenerationScreen(),
    );
  }
}

class PDFGenerationScreen extends StatefulWidget {
  const PDFGenerationScreen({super.key});

  @override
  State<PDFGenerationScreen> createState() => _PDFGenerationScreenState();
}

class _PDFGenerationScreenState extends State<PDFGenerationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> billingCards = [];

  String clientId = '';
  String clientName = '';
  String tradeId = '';
  String totalCharges = '';

  void addBillingCard() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      billingCards.add({
        'clientId': clientId,
        'clientName': clientName,
        'tradeId': tradeId,
        'totalCharges': totalCharges,
      });
      clearForm();
    });
  }

  void clearForm() {
    setState(() {
      clientId = '';
      clientName = '';
      tradeId = '';
      totalCharges = '';
    });
  }

  void deleteCard(Map<String, dynamic> card) {
    setState(() {
      billingCards.remove(card);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Generation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Billing Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Billing ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt),
                    ),
                    onChanged: (value) {
                      clientId = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Billing ID is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Client Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      clientName = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Client Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Trade ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.tag),
                    ),
                    onChanged: (value) {
                      tradeId = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Trade ID is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Charges',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money),
                    ),
                    onChanged: (value) {
                      totalCharges = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Total Charges is required' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: addBillingCard,
                    child: const Text('Add Billing Info'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: billingCards.isEmpty
                  ? const Center(
                      child: Text(
                        'No billing information added yet!',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: billingCards.length,
                      itemBuilder: (context, index) {
                        final billing = billingCards[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Billing ID: ${billing['clientId']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Client Name: ${billing['clientName']}'),
                                Text('Trade ID: ${billing['tradeId']}'),
                                Text('Total Charges: ${billing['totalCharges']}'),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                     
                                        print('Generating PDF for ${billing['clientId']}');
                                      },
                                      icon: const Icon(Icons.picture_as_pdf),
                                      label: const Text('Generate PDF'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                    
                                        print('Downloading PDF for ${billing['clientId']}');
                                      },
                                      icon: const Icon(Icons.download),
                                      label: const Text('Download PDF'),
                                    ),
                                    IconButton(
                                      onPressed: () => deleteCard(billing),
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ],
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
    );
  }
}
