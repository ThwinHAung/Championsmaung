import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class SSSeniorMemberDetails extends StatefulWidget {
  static String id = 'sssenior_member_details';
  const SSSeniorMemberDetails({super.key});

  @override
  State<SSSeniorMemberDetails> createState() => _SSSeniorMemberDetailsState();
}

class _SSSeniorMemberDetailsState extends State<SSSeniorMemberDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Members Details',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kBlue, // Active tab text color
          unselectedLabelColor: kGrey, // Inactive tab text color
          indicatorColor: kBlue, // Active tab indicator color
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Transcations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DetailsTab(),
          TranscationsTab(color: Colors.blue, text: 'Content of Tab 2'),
        ],
      ),
    );
  }
}

class DetailsTab extends StatefulWidget {
  const DetailsTab({super.key});

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kOnPrimaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: bigCapText('Basic Info'),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            color: kBlue,
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('Name'),
                              labelText('Username'),
                              labelText('Mobile'),
                              labelText('Balance'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('-'),
                              labelText('-'),
                              labelText('-'),
                              labelText('-'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('Name'),
                              labelText('Username'),
                              labelText('Mobile'),
                              labelText('Balance'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(
                                kSecondary, 'Reset Password', () {})),
                        SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(
                                kError, 'Manange Balance', () {})),
                        SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kGreen, 'Suspend', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kOnPrimaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: bigCapText('Share Detail'),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            color: kBlue,
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('Share Percentage'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('-'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('0'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kOnPrimaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: bigCapText('Bet Limitations'),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            color: kBlue,
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('Mix Bet Limitation'),
                              labelText('Single Bet Limitation'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('-'),
                              labelText('-'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('0'),
                              labelText('0'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kOnPrimaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: bigCapText('Single Bet Commision'),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            color: kBlue,
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('Commision'),
                              labelText('Tax'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('-'),
                              labelText('-'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('0'),
                              labelText('0'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('High Commision'),
                              labelText('High Tax'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('-'),
                              labelText('-'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText('0'),
                              labelText('0'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kOnPrimaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      child: bigCapText('Mix Bet Commision'),
                      alignment: Alignment.topLeft,
                    ),
                    Divider(),
                    Container(
                      child: MixBetCommisionView(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget MixBetCommisionView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: listTitleText('No.'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Name'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Username'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Balance'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Details'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListCard();
                }),
          ),
        ],
      ),
    );
  }

  Widget ListCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: listText(''),
        ),
        Expanded(
          flex: 5,
          child: listText('name'),
        ),
        Expanded(
          flex: 5,
          child: listText(''),
        ),
        Expanded(
          flex: 5,
          child: listText(''),
        ),
        Expanded(
          flex: 5,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.info_outline,
                color: kBlue,
                size: 20,
              ),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class TranscationsTab extends StatelessWidget {
  final Color color;
  final String text;

  const TranscationsTab({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
    );
  }
}
