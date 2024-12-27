// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panjatan_app/constants.dart';

class ViewSawalScreen extends StatefulWidget {
  const ViewSawalScreen({super.key});

  @override
  _ViewSawalScreenState createState() => _ViewSawalScreenState();
}

class _ViewSawalScreenState extends State<ViewSawalScreen> {
  List<dynamic> sawalList = [];
  bool isLoading = true;

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
  Future<void> deleteSawal(String id) async {
    final url = SAWAL_JAWAB_API;
    try {
      final response = await http.post(Uri.parse(url), body: {'id': id});
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        fetchSawalData(); // Refresh the list after deletion
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sawal deleted successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete sawal')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
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
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading spinner while fetching data
          : sawalList.isEmpty
              ? Center(
                  child: Text(
                      'No data found')) // Show message if no data is available
              : ListView.builder(
                  itemCount: sawalList.length,
                  itemBuilder: (ctx, index) {
                    final sawalItem = sawalList[index];
                    return ListTile(
                      title: Text(sawalItem['sawal']),
                      subtitle: Text('Category: ${sawalItem['category']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Navigate to update screen (optional)
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteSawal(
                                  sawalItem['id'].toString()); // Delete record
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
