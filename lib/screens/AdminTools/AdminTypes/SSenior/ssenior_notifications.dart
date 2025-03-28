import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class SSeniorNotifications extends StatefulWidget {
  const SSeniorNotifications({super.key});

  static const String id = 'ssenior_notifications';

  @override
  State<SSeniorNotifications> createState() => _SSeniorNotifications();
}

class _SSeniorNotifications extends State<SSeniorNotifications> {

  final List<String> _titles = ['Title 1', 'Title 2', 'Title 3'];

  final List<String> _contents = ['content 1', 'content 2', 'content 3'];

  Widget view() {
    return Column(
      children: [
        Expanded(
          child: _contents.isEmpty
              ? const Center(child: Text('No notifications added.'))
                : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: kOnPrimaryContainer,
                    elevation: .5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            _titles[index],
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
                            _contents[index],
                            style: const TextStyle(
                              color: kBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                            ),
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
        ),],
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
    );
  }
}
