import 'package:flutter/material.dart';

class TransactionManagement extends StatefulWidget {
  @override
  _TransactionManagementState createState() => _TransactionManagementState();
}

class Transaction {
  final String transactionDate;
  final String clientId;
  final String tradeId;
  final String stockName;
  final int quantity;
  final String tradeType;
  final String settlementStatus;

  Transaction({
    required this.transactionDate,
    required this.clientId,
    required this.tradeId,
    required this.stockName,
    required this.quantity,
    required this.tradeType,
    required this.settlementStatus,
  });
}

class _TransactionManagementState extends State<TransactionManagement> {
  final _formKey = GlobalKey<FormState>();
  final List<Transaction> _transactions = [];


  String transactionDate = '';
  String clientId = '';
  String tradeId = '';
  String stockName = '';
  int quantity = 0;
  String? tradeType;
  String? settlementStatus;

  final List<String> tradeTypes = ['Buy', 'Sell'];
  final List<String> settlementStatuses = ['Pending', 'Completed'];

 
  void _updateTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
     
        final updatedTransaction = Transaction(
          transactionDate: transactionDate,
          clientId: clientId,
          tradeId: tradeId,
          stockName: stockName,
          quantity: quantity,
          tradeType: tradeType!,
          settlementStatus: settlementStatus!,
        );

        
        if (_editingTransaction != null) {
          _transactions[_transactions.indexOf(_editingTransaction!)] = updatedTransaction;
        } else {
          _transactions.add(updatedTransaction);
        }
      });


      _formKey.currentState!.reset();
      transactionDate = '';
      clientId = '';
      tradeId = '';
      stockName = '';
      quantity = 0;
      tradeType = null;
      settlementStatus = null;
      _editingTransaction = null; 
    }
  }


  Transaction? _editingTransaction;

  void _editTransaction(Transaction transaction) {
    setState(() {
      _editingTransaction = transaction;
      transactionDate = transaction.transactionDate;
      clientId = transaction.clientId;
      tradeId = transaction.tradeId;
      stockName = transaction.stockName;
      quantity = transaction.quantity;
      tradeType = transaction.tradeType;
      settlementStatus = transaction.settlementStatus;
    });
  }


  void _deleteTransaction(Transaction transaction) {
    setState(() {
      _transactions.remove(transaction);
    });
  }


  void _viewTransactionDetails(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Transaction Date: ${transaction.transactionDate}'),
            Text('Client ID: ${transaction.clientId}'),
            Text('Trade ID: ${transaction.tradeId}'),
            Text('Stock Name: ${transaction.stockName}'),
            Text('Quantity: ${transaction.quantity}'),
            Text('Trade Type: ${transaction.tradeType}'),
            Text('Settlement Status: ${transaction.settlementStatus}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Transaction Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onSaved: (value) => transactionDate = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Transaction Date is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Client ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onSaved: (value) => clientId = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Client ID is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Trade ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.trending_up),
                    ),
                    onSaved: (value) => tradeId = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Trade ID is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Stock Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label),
                    ),
                    onSaved: (value) => stockName = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Stock Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.exposure_plus_1),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => quantity = int.tryParse(value ?? '0') ?? 0,
                    validator: (value) =>
                        value == null || int.tryParse(value) == null || int.parse(value) <= 0
                            ? 'Quantity must be greater than 0'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: tradeType,
                    decoration: const InputDecoration(
                      labelText: 'Trade Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.swap_horiz),
                    ),
                    items: tradeTypes
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => tradeType = value),
                    validator: (value) =>
                        value == null ? 'Trade Type is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: settlementStatus,
                    decoration: const InputDecoration(
                      labelText: 'Settlement Status',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.check_circle),
                    ),
                    items: settlementStatuses
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => settlementStatus = value),
                    validator: (value) =>
                        value == null ? 'Settlement Status is required' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateTransaction,
                    child: const Text('Add/Update Transaction'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Transaction list
            _transactions.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions added yet!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            '${transaction.tradeId} - ${transaction.stockName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Client: ${transaction.clientId}\nDate: ${transaction.transactionDate}\nQuantity: ${transaction.quantity}\nTrade Type: ${transaction.tradeType}\nStatus: ${transaction.settlementStatus}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editTransaction(transaction),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTransaction(transaction),
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility, color: Colors.green),
                                onPressed: () => _viewTransactionDetails(transaction),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
