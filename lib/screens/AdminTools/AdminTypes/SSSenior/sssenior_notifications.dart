import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NotificationModel {
  final int id;
  final String title;
  final String message;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
    );
  }
}

class SSSeniorNotifications extends StatefulWidget {
  const SSSeniorNotifications({super.key});

  static const String id = 'sssenior_notifications';

  @override
  State<SSSeniorNotifications> createState() => _SSSeniorNotificationsState();
}

class _SSSeniorNotificationsState extends State<SSSeniorNotifications> {
  final storage = const FlutterSecureStorage();
  List<NotificationModel> notifications = [];
  String? _token;
  final TextEditingController _titlesController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');

    if (_token != null) {
      setState(() {
        _fetchNotifications();
      });
    }
  }

  Future<void> _fetchNotifications() async {
    var url = Uri.parse('${Config.apiUrl}/fetch_noti');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['data'];
      setState(() {
        notifications = jsonResponse
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();
      });
    } else {
      print("Failed to load notifications");
    }
  }

  Future<void> _insertNotification() async {
    if (_titlesController.text.isEmpty || _contentsController.text.isEmpty) {
      _showErrorDialog('Title and Content cannot be empty', 'Error');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/noti_announce'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type':
              'application/json', // ✅ Important for Laravel to detect JSON
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(<String, String>{
          'title': _titlesController.text,
          'message': _contentsController.text,
        }),
      );
      if (response.statusCode == 200) {
        _showErrorDialog('Successfully created', 'Success');
        _fetchNotifications();
      } else {
        print(response.body);
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again.', 'Error');
    }
  }

  Future<void> _updateNotification(int id) async {
    if (_titlesController.text.isEmpty || _contentsController.text.isEmpty) {
      _showErrorDialog('Title and Content cannot be empty', 'Error');
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('${Config.apiUrl}/edit_noti/$id'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(<String, String>{
          'title': _titlesController.text,
          'message': _contentsController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showErrorDialog('Successfully updated', 'Success');
        _fetchNotifications(); // Refresh notifications list
      } else {
        _showErrorDialog('Failed to update. Try again.', 'Error');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again.', 'Error');
    }
    Navigator.pop(context);
  }

  Future<void> _deleteNotification(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.apiUrl}/delete_noti/$id'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        _showErrorDialog('Successfully deleted', 'Success');
        _fetchNotifications(); // Refresh the list after deletion
      } else {
        _showErrorDialog('Failed to delete. Try again.', 'Error');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again.', 'Error');
    }
  }

  void _showErrorDialog(String message, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(status),
        content: Text(message),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 1,
                child: materialButton(kBlue, 'OK', () {
                  setState(() {
                    Navigator.pop(context);
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget view() {
    return Column(
      children: [
        Expanded(
          child: notifications.isEmpty
              ? const Center(child: Text('No notifications added.'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      color: kOnPrimaryContainer,
                      elevation: .5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              notification.title,
                              style: const TextStyle(
                                color: kBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: kBlue),
                                  onPressed: () =>
                                      _editNotification(notification),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: kError),
                                  onPressed: () =>
                                      _removeNotification(notification.id),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              notification.message,
                              style: const TextStyle(
                                  color: kBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showAddNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Add and send notifications to users.'),
        actions: <Widget>[
          Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _titlesController,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _contentsController,
                  maxLines: 5,
                  style: kTextFieldActiveStyle,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Content'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Content cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: materialButton(kError, 'Cancel', () {
                        _contentsController.clear();
                        Navigator.pop(context);
                      }),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'Add', () {
                        _insertNotification();
                        Navigator.pop(context);
                        // _addNotification();
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editNotification(NotificationModel notification) {
    _titlesController.text = notification.title; // Pre-fill title
    _contentsController.text = notification.message; // Pre-fill message

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Edit and update the notification.'),
        actions: <Widget>[
          Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _titlesController,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _contentsController,
                  maxLines: 5,
                  style: kTextFieldActiveStyle,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Content'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Content cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: materialButton(kError, 'Cancel', () {
                        _titlesController.clear();
                        _contentsController.clear();
                        Navigator.pop(context);
                      }),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'Update', () {
                        _updateNotification(notification.id);
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeNotification(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Do you want to remove this notification?'),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: materialButton(kError, 'Cancel', () {
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                flex: 1,
                child: materialButton(kBlue, 'Remove', () {
                  setState(() {
                    _deleteNotification(id);
                  });
                  Navigator.pop(context);
                }),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: view(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNotificationDialog,
        backgroundColor: kBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add, color: kPrimary),
      ),
    );
  }
}
