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

class UserNotifications extends StatefulWidget {
  const UserNotifications({super.key});

  static const String id = 'user_notifications';

  @override
  State<UserNotifications> createState() => _UserNotifications();
}

class _UserNotifications extends State<UserNotifications> {
  final storage = const FlutterSecureStorage();
  List<NotificationModel> notifications = [];
  String? _token;

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

  Widget view() {
    return Column(
      children: [
        Expanded(
          child: notifications.isEmpty
              ? const Center(child: Text('No notifications added.'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
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
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: view(),
          ),
        ),
      ),
    );
  }
}
