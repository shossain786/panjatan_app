// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panjatan_app/constants.dart';

class AddSawalScreen extends StatefulWidget {
  const AddSawalScreen({super.key});

  @override
  _AddSawalScreenState createState() => _AddSawalScreenState();
}

class _AddSawalScreenState extends State<AddSawalScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController sawalController = TextEditingController();
  TextEditingController jawabController = TextEditingController();
  String? selectedCategory;

  // List of categories for the dropdown
  final List<String> categories = [
    'Imaan',
    'Namaaz',
    'Roza',
    'Hajj',
    'Zakaat',
    'Taharat',
    'Others'
  ];

  Future<void> submitSawal() async {
    if (_formKey.currentState!.validate()) {
      String sawal = sawalController.text;
      String jawab = jawabController.text;
      String category = selectedCategory ?? '';

      final url = SAWAL_JAWAB_API;
      final response = await http.post(Uri.parse(url), body: {
        'sawal': sawal,
        'jawab': jawab,
        'category': category,
      });

      if (response.statusCode == 200) {
        // Handle success response
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sawal added successfully!')));
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseData['message']}')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add sawal')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sawal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  // Sawal input
                  TextFormField(
                    controller: sawalController,
                    decoration: InputDecoration(
                      labelText: 'Sawal',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your sawal',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter sawal';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Jawab input
                  TextFormField(
                    controller: jawabController,
                    decoration: InputDecoration(
                      labelText: 'Jawab',
                      border: OutlineInputBorder(),
                      hintText: 'Enter the jawab',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter jawab';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Category dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Submit button with animation
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: ElevatedButton(
                      onPressed: submitSawal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
