// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panjatan_app/constants.dart';
import 'package:panjatan_app/widgets/app_background.dart';

class ViewSawalScreen extends StatefulWidget {
  const ViewSawalScreen({super.key});

  @override
  _ViewSawalScreenState createState() => _ViewSawalScreenState();
}

class _ViewSawalScreenState extends State<ViewSawalScreen>
    with SingleTickerProviderStateMixin {
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
            : sawalList.isEmpty
                ? Center(child: Text('No data found'))
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: sawalList.length,
                    itemBuilder: (ctx, index) {
                      final sawalItem = sawalList[index];
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
                            subtitle: Text(
                              'Category: ${sawalItem['category']}',
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteSawal(sawalItem['id']);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
