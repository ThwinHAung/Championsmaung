import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class SSSeniorNotifications extends StatefulWidget {
  const SSSeniorNotifications({super.key});

  static const String id = 'sssenior_notifications';

  @override
  State<SSSeniorNotifications> createState() => _SSSeniorNotificationsState();
}

class _SSSeniorNotificationsState extends State<SSSeniorNotifications> {
  final List<String> _titles = [];
  final TextEditingController _titlesController = TextEditingController();

  final List<String> _contents = [];
  final TextEditingController _contentsController = TextEditingController();

  Widget view() {
    return Column(
      children: [
        Expanded(
          child: _contents.isEmpty
              ? const Center(child: Text('No notifications added.'))
              : ListView.builder(
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: kBlue),
                                  onPressed: () => _editNotification(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: kError),
                                  onPressed: () => _removeNotification(index),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              _contents[index],
                              style: const TextStyle(
                                color: kBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
        ),
      ],
    );
  }

  void _showAddNotificationDialog() {
    _titlesController.clear();
    _contentsController.clear();
    _showNotificationDialog(isEditing: false);
  }

  void _editNotification(int index) {
    _titlesController.text = _titles[index];
    _contentsController.text = _contents[index];
    _showNotificationDialog(isEditing: true, index: index);
  }

  void _showNotificationDialog({required bool isEditing, int? index}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(isEditing ? 'Edit your notification.' : 'Add and send notifications to users.'),
        actions: <Widget>[
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                bigCapText('Title'),
                const SizedBox(height: 5.0,),
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
                const SizedBox(height: 10.0),
                bigCapText('Content'),
                const SizedBox(height: 5.0,),
                TextFormField(
                  controller: _contentsController,
                  maxLines: 5,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Content'),
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
                      child: materialButton(kBlue, isEditing ? 'Update' : 'Add', () {
                        if (isEditing && index != null) {
                          _updateNotification(index);
                        } else {
                          _addNotification();
                        }
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

  void _addNotification() {
    final title = _titlesController.text.trim();
    final content = _contentsController.text.trim();
    if (title.isNotEmpty && content.isNotEmpty) {
      setState(() {
        _titles.add(title);
        _contents.add(content);
      });
      Navigator.pop(context);
    }
  }

  void _updateNotification(int index) {
    final updatedTitle = _titlesController.text.trim();
    final updatedContent = _contentsController.text.trim();
    if (updatedTitle.isNotEmpty && updatedContent.isNotEmpty) {
      setState(() {
        _titles[index] = updatedTitle;
        _contents[index] = updatedContent;
      });
      Navigator.pop(context);
    }
  }

  void _removeNotification(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
      backgroundColor: kPrimary, // Add background color here
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
            _titles.removeAt(index);
            _contents.removeAt(index);
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
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: view(),
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
