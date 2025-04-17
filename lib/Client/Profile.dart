import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController panCardController = TextEditingController();
  TextEditingController kycStatusController = TextEditingController();
  TextEditingController nomineeController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isEditable = false; 

  @override
  void initState() {
    fetchMethod();

    super.initState();
  }

  Map clientDetails = {};
  fetchMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Client = prefs.getString("ClientData") ?? "";
    print("getmethod:::::::::::$Client");
    clientDetails = jsonDecode(Client);
    await clientdata();
  }

  clientdata() {
    firstNameController.text = clientDetails["first_name"];
    lastNameController.text = clientDetails["last_name"];
    emailController.text = clientDetails["email"];
    phoneController.text = clientDetails["phone_number"];
    panCardController.text = clientDetails["pan_card"];
    nomineeController.text = clientDetails["nominee_name"];
    kycStatusController.text = clientDetails["kyc_status"];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
          
            Card(
              elevation: 4,
              margin:
                  const EdgeInsets.only(bottom: 16.0), 
              child: Padding(
                padding: const EdgeInsets.all(20.0), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                
                    TextFormField(
                      controller: firstNameController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,
                            color: isEditable
                                ? Color(0x663F9C6E)
                                : Colors.deepPurple),
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable
                                  ? Color(0x663F9C6E)
                                  : Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable
                                  ? Color(0x663F9C6E)
                                  : Colors.deepPurple),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
               
                    TextFormField(
                      controller: lastNameController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  
                    TextFormField(
                      controller: emailController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
      
                    TextFormField(
                      controller: phoneController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    TextFormField(
                      controller: panCardController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.credit_card,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Pan Card Number',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    TextFormField(
                      controller: kycStatusController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.check_circle,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'KYC Status',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

        
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nominee Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
        
                    TextFormField(
                      controller: nomineeController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_add,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Nominee Name',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank Details',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    _buildDropdown(
                      label: 'Bank Name',
                      icon: Icons.home,
                      items: ['Bank 1', 'Bank 2', 'Bank 3'],
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Branch Name',
                      icon: Icons.location_on,
                      items: ['Branch 1', 'Branch 2', 'Branch 3'],
                    ),
                    const SizedBox(height: 16),
               
                    TextFormField(
                      controller: ifscController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.code,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'IFSC Code',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
   
                    TextFormField(
                      controller: accountNumberController,
                      readOnly: !isEditable,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_balance,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Bank Account Number',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

    
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                 
                    TextFormField(
                      controller: addressController,
                      readOnly: !isEditable,
                      maxLines: 5,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.home,
                            color: isEditable ? Colors.blue : Colors.grey),
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isEditable ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditable = !isEditable;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditable ? Colors.green : Colors.orange,
                  ),
                  child: Text(isEditable ? 'Save' : 'Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      value: items.isNotEmpty ? items[0] : null,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: isEditable
          ? (value) {
              
            }
          : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: isEditable ? Colors.blue : Colors.grey),
        labelText: label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isEditable ? Colors.blue : Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isEditable ? Colors.blue : Colors.grey),
        ),
      ),
    );
  }
}
