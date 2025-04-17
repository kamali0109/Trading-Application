import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => UserManagementPage();
}

class UserManagementPage extends State<UserManagement> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String? role;
  String? status;

  List<String> roles = ['Client', 'Back Office Admin', 'Billing Approver'];
  List<String> statuses = ['Active', 'Inactive'];

  List<Map<String, String>> users = []; 

  // Save user data
  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        users.add({
          'userId': '${users.length + 1}', 
          'username': username,
          'role': role ?? '',
          'status': status ?? '',
        });
      });
     
      username = '';
      role = null;
      status = null;
    }
  }


  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        username = value;
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Username is required' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                        
                      ),
                      value: role,
                      items: roles.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        role = newValue;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a role' : null,
                    ),
                    const SizedBox(height: 16),
                    // Status Input
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      value: status,
                      items: statuses.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        status = newValue;
                      },
                      validator: (value) =>
                          value == null ? 'Please select a status' : null,
                    ),
                    const SizedBox(height: 16),
                    // Save Button
                    ElevatedButton(
                      onPressed: _saveUser,
                      child: const Text('Save User'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Display users in Cards
              Expanded(
                child: users.isEmpty
                    ? const Center(
                        child: Text('No users available'),
                      )
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                '${user['userId']} - ${user['username']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Role: ${user['role']}\nStatus: ${user['status']}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUser(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
