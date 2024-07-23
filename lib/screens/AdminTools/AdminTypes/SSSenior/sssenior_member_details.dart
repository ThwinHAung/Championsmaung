import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/member_details_detailsTab.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/member_details_transcationTab.dart';
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
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DetailsTab(),
          TransactionsTab(),
        ],
      ),
    );
  }
}
