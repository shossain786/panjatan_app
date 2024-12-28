// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panjatan_app/constants.dart';
import 'package:panjatan_app/models/category.dart';
import 'package:panjatan_app/widgets/app_background.dart';

class ViewSawalScreen extends StatefulWidget {
  const ViewSawalScreen({super.key});

  @override
  _ViewSawalScreenState createState() => _ViewSawalScreenState();
}

class _ViewSawalScreenState extends State<ViewSawalScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> sawalList = [];
  List<dynamic> filteredSawalList = [];
  bool isLoading = true;
  String selectedCategory = ''; // Store selected category
  int? expandedIndex; // Track the index of the expanded tile

  // Fetch data from the GET API
  Future<void> fetchSawalData() async {
    final url = SAWAL_JAWAB_API;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            sawalList = responseData['data'];
            filteredSawalList = sawalList; // Initially, show all
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('No data found')));
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load data')));
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  // Delete a sawal
  Future<void> deleteSawal(int id) async {
    final url = SAWAL_JAWAB_API; // Your API endpoint
    try {
      final request = http.Request('DELETE', Uri.parse(url))
        ..headers.addAll({'Content-Type': 'application/json'})
        ..body = json.encode({"id": id});

      final response = await http.Client().send(request);
      final responseData = await http.Response.fromStream(response);

      if (responseData.statusCode == 200) {
        final decodedResponse = json.decode(responseData.body);
        if (decodedResponse['status'] == 'success') {
          await fetchSawalData(); // Refresh the list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sawal deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete sawal')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete sawal')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Handle Category selection
  void handleCategoryChange(String? category) {
    setState(
      () {
        selectedCategory = category ?? '';
        // Filter based on the selected category
        if (selectedCategory.isEmpty) {
          filteredSawalList = sawalList; // Show all if no category selected
        } else {
          filteredSawalList = sawalList.where((item) {
            // Compare category of the sawal with the selected category
            return item['category'] == selectedCategory;
          }).toList();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSawalData(); // Fetch data when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Sawal'),
        centerTitle: true,
      ),
      body: Container(
        decoration: myScreenBG(),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Category Dropdown
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value:
                            selectedCategory.isEmpty ? null : selectedCategory,
                        hint: Text('Select Category'),
                        onChanged: handleCategoryChange,
                        items: CategoryHelper.getAllCategories()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                  Expanded(
                    child: filteredSawalList.isEmpty
                        ? Center(child: Text('No data found'))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: filteredSawalList.length,
                            itemBuilder: (ctx, index) {
                              final sawalItem = filteredSawalList[index];
                              bool isExpanded = expandedIndex == index;

                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      sawalItem['sawal'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: isExpanded
                                        ? Text(
                                            'Answer: ${sawalItem['jawab']}',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          )
                                        : null,
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteSawal(sawalItem['id']);
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        // Toggle expanded state for the tapped tile
                                        expandedIndex =
                                            isExpanded ? null : index;
                                      });
                                    },
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
