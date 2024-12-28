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
Future<void> deleteSawal(int id) async {
  final url = SAWAL_JAWAB_API; // Your API endpoint
  try {
    print('Deleting Sawal with ID: $id'); // Debugging

    // Create a DELETE request manually
    final request = http.Request('DELETE', Uri.parse(url))
      ..headers.addAll({'Content-Type': 'application/json'})
      ..body = json.encode({"id": id});

    // Send the request
    final response = await http.Client().send(request);
    final responseData = await http.Response.fromStream(response);

    print('Response Code: ${responseData.statusCode}');
    print('Response Body: ${responseData.body}');

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
    print('Error: $error'); // Debugging
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
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
          ? Center(child: CircularProgressIndicator())
          : sawalList.isEmpty
              ? Center(child: Text('No data found'))
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
                          // IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {},
                          // ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteSawal(sawalItem['id']);
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
