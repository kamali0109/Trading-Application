import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradeapp/Client/login.dart';
import 'package:tradeapp/repository/Apifile.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _FirstnameController = TextEditingController();
  TextEditingController _LastnameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _ConfirmpasswordController = TextEditingController();
  TextEditingController _PhoneController = TextEditingController();
  TextEditingController _PanController = TextEditingController();
  TextEditingController _NomineeController = TextEditingController();
  TextEditingController _BankController = TextEditingController();
  TextEditingController _BranchController = TextEditingController();
  TextEditingController _IfscController = TextEditingController();
  TextEditingController _accountnoController = TextEditingController();
  TextEditingController _AddressController = TextEditingController();
  List<String> dropdownoptions = ['SBI', 'IOB', 'BOB', 'HDFC'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Registration',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(
            (0x665ac18e),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(scrollDirection: Axis.vertical, children: [
                Column(children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _FirstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return 'Please enter a valid Name';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(
                            (0x663F9C6E),
                          ),
                        ),
                        suffixIcon: InkWell(
                            onTap: () {
                              _FirstnameController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Firstname'),
                        hintText: 'Firstname',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _LastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return 'Please enter a valid Name';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.co_present_rounded,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _LastnameController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Lastname'),
                        hintText: 'Lastname',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _EmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _EmailController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Email'),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _PasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z0-9\s]+$").hasMatch(value)) {
                        return 'Please enter a valid Password';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.remove_red_eye,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _PasswordController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Password'),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _ConfirmpasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z0-9\s]+$").hasMatch(value)) {
                        return 'Please enter a valid Password';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _ConfirmpasswordController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Confirm Password'),
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _PhoneController,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[{10}r0-9/s]+$").hasMatch(value)) {
                        return 'Please enter a valid Phone number';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _PhoneController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Phone Number'),
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _PanController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid Pan number';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_balance_wallet,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _PanController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('PAN Card Number'),
                        hintText: 'PAN Card Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _NomineeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return 'Please enter a valid Name';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_add_alt_1,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _NomineeController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Nominee Name'),
                        hintText: 'Nominee Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            label: Text('Bank'),
                            filled: false,
                            prefixIcon: Icon(Icons.account_balance,
                                color: Color(
                                  (0x663F9C6E),
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        value: 'SBI',
                        onChanged: (String? newValue) {
                          // setState(() {
                          //   dropdownValue2 = newValue!;
                          // });
                        },
                        items: dropdownoptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _BranchController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return 'Please enter a valid Branch Name';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.holiday_village_rounded,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        label: Text('Branch Name'),
                        suffixIcon: InkWell(
                            onTap: () {
                              _BranchController.clear();
                            },
                            child: Icon(Icons.close)),
                        hintText: 'Branch Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _IfscController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid IFSC code';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_card,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _IfscController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('IFSC Code'),
                        hintText: 'IFSC Code',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _accountnoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else if (!RegExp(r"^[0-9/s]+$").hasMatch(value)) {
                        return 'Please enter a valid Account number';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _accountnoController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Account Number'),
                        hintText: 'Bank Account Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: null,
                    controller: _AddressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the value';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.room,
                            color: Color(
                              (0x663F9C6E),
                            )),
                        suffixIcon: InkWell(
                            onTap: () {
                              _AddressController.clear();
                            },
                            child: Icon(Icons.close)),
                        label: Text('Address'),
                        hintText: 'Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          Map body = {
                            "first_name": _FirstnameController.text,
                            "last_name": _LastnameController.text,
                            "email": _EmailController.text,
                            "password": _PasswordController.text,
                            "phone_number": _PhoneController.text,
                            "pan_card": _PanController.text,
                            "nominee_name": _NomineeController.text
                          };

                          print("body$body");
                          try {
                            Map response = await Apicall().registerpost(body);
                            if (response.isNotEmpty) {
                              if (response["status"] == "S") {
                                print(response);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => login(),
                                ));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Register Successfully!! ClientID  ${response["client_Id"]} remember for that login"),
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 105, 54),
                                  duration: Duration(seconds: 5),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Register not successfully, Try again"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 3),
                              ));
                            }
                          } catch (e) {
                            print("Error: $e");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "An error occurred. Please try again later."),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 3),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Please fill all the fields correctly."),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3),
                          ));
                        }
                      },
                      child: Text('Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 85, 163, 124),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)))
                ]),
              ])),
        ));
  }
}
