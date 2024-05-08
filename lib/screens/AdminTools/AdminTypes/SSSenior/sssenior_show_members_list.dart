import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class SSSeniorShowMembersList extends StatefulWidget {
  static String id = "sssenior_show_members_list";
  const SSSeniorShowMembersList({super.key});

  @override
  State<SSSeniorShowMembersList> createState() =>
      _SSSeniorShowMembersListState();
}

class _SSSeniorShowMembersListState extends State<SSSeniorShowMembersList> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grapes',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Peach',
    'Pineapple',
    'Strawberry',
    'Watermelon'
  ];
  List<String> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = _data;
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _controller.text.toLowerCase();
    setState(() {
      _filteredData =
          _data.where((item) => item.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Members List',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        color: kPrimary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: kOnPrimaryContainer,
                borderRadius: BorderRadius.circular(10)),
            child: view(),
          ),
        ),
      ),
    );
  }

  Widget view() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: listTitleText('ID'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Username'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Phone Number'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Units'),
              ),
              Expanded(
                flex: 7,
                child: listTitleText('Add/Reduce units'),
              ),
              Expanded(
                flex: 7,
                child: listTitleText('Delete/Postpone'),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                return ListCard(_data[index].toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard(String data) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: listText('1'),
        ),
        Expanded(
          flex: 5,
          child: listText(data),
        ),
        Expanded(
          flex: 5,
          child: listText('09400104050'),
        ),
        Expanded(flex: 3, child: listText('50')),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  '-',
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  fixedSize: Size(5, 5),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '+',
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  fixedSize: Size(5, 5),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Icon(Icons.delete_outline_outlined),
                style: TextButton.styleFrom(
                    fixedSize: Size(5, 5), iconColor: kError),
              ),
              TextButton(
                onPressed: () {},
                child: Icon(Icons.error_outline),
                style: TextButton.styleFrom(
                    fixedSize: Size(5, 5), iconColor: kError),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
