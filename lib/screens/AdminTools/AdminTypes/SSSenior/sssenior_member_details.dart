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
                            onPressed: () {
                              basicInfoEditDialog(context);
                            },
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
                            child: materialButton(kSecondary, 'Reset Password',
                                () {
                          resetPasswordDialog(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kError, 'Manage Balance', () {
                          manageBalanceDialog(context);
                        })),
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
                            onPressed: () {
                              shareDetailDialog(context);
                            },
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
                            onPressed: () {
                              betLimitationsDialog(context);
                            },
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
                          child: bigCapText('Single Bet Commission'),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            color: kBlue,
                            onPressed: () {
                              singleBetCommisionDialog(context);
                            },
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
                              labelText('Commission'),
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
                              labelText('High Commission'),
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
                      child: bigCapText('Mix Bet Commission'),
                      alignment: Alignment.topLeft,
                    ),
                    Divider(),
                    Container(
                      child: MixBetCommissionView(),
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

  Widget MixBetCommissionView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: listTitleText('Match Count'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Tax'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Commission'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Action'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 300, // Set a fixed height
            child: Column(
              children: [
                ListCard(
                    matchCount: '2',
                    tax: '15',
                    commission: '7',
                    onPressed: () {
                      mcTwoCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '3',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcThreeCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '4',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcFourCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '5',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcFiveCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '6',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcSixCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '7',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcSevenCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '8',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcEightCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '9',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcNineCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '10',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcTenCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '11',
                    tax: '20',
                    commission: '15',
                    onPressed: () {
                      mcElevenCommisionDialog(context);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard({
    required String matchCount,
    required String tax,
    required String commission,
    required Function onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: listText(matchCount),
        ),
        Expanded(
          flex: 3,
          child: listText(tax),
        ),
        Expanded(
          flex: 5,
          child: listText(commission),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.edit_outlined,
                color: kBlue,
                size: 20,
              ),
            ),
            onTap: () {
              onPressed();
            },
          ),
        ),
      ],
    );
  }

  //THESE ARE THE CONTROLLERS
  //THESE ARE THE CONTROLLERS
  //THESE ARE THE CONTROLLERS

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _phoneNumberEditController =
      TextEditingController();
  final TextEditingController _sharePercentageEditController =
      TextEditingController();
  final TextEditingController _mixBetLimitationEditController =
      TextEditingController();
  final TextEditingController _singleBetLimitationEditController =
      TextEditingController();
  final TextEditingController _commisionEditController =
      TextEditingController();
  final TextEditingController _highCommisionEditController =
      TextEditingController();
  final TextEditingController _mcTwoCommisionEditController =
      TextEditingController();
  final TextEditingController _mcThreeCommisionEditController =
      TextEditingController();
  final TextEditingController _mcFourCommisionEditController =
      TextEditingController();
  final TextEditingController _mcFiveCommisionEditController =
      TextEditingController();
  final TextEditingController _mcSixCommisionEditController =
      TextEditingController();
  final TextEditingController _mcSevenCommisionEditController =
      TextEditingController();
  final TextEditingController _mcEightCommisionEditController =
      TextEditingController();
  final TextEditingController _mcNineCommisionEditController =
      TextEditingController();
  final TextEditingController _mcTenCommisionEditController =
      TextEditingController();
  final TextEditingController _mcElevenCommisionEditController =
      TextEditingController();

  void resetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Reset password'),
                    Divider(),
                    TextFormField(
                      controller: _newPasswordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'New Password',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Confrim New Password',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void manageBalanceDialog(BuildContext context) {
    // Define state variables for radio buttons and checkbox
    int _radioValue = 0; // Default radio button value
    bool _checkboxValue = false; // Default checkbox value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Reset password'),
                    Divider(),
                    // Add Radio widgets inside a Row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio<int>(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    _radioValue = value!;
                                  });
                                },
                              ),
                              labelText('Add'),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<int>(
                                value: 2,
                                groupValue: _radioValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    _radioValue = value!;
                                  });
                                },
                              ),
                              labelText('Remove'),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _newPasswordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'New Password',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Confrim New Password',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Add CheckboxListTile widget here
                    CheckboxListTile(
                      title: const Text('Credit'),
                      value: _checkboxValue,
                      onChanged: (bool? value) {
                        setState(() {
                          _checkboxValue = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void basicInfoEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Basic Info'),
                    Divider(),
                    TextFormField(
                      controller: _nameEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _phoneNumberEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Phone Number',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void shareDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Share Detail'),
                    Divider(),
                    TextFormField(
                      controller: _sharePercentageEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Share Percentage',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void betLimitationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Bet Limitation'),
                    Divider(),
                    TextFormField(
                      controller: _mixBetLimitationEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Mix Bet Limitation',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _singleBetLimitationEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Single Bet Limitation',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void singleBetCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Single Bet Commision'),
                    Divider(),
                    TextFormField(
                      controller: _commisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Commision',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _highCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'High Commision',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mixBetCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Basic Info'),
                    Divider(),
                    TextFormField(
                      controller: _nameEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _phoneNumberEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Phone Number',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///MIXED BET COMMISION DIALOGS
  void mcTwoCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 2 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcTwoCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '7',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcThreeCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 3 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcThreeCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcFourCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 4 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcFourCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcFiveCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 5 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcFiveCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcSixCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 6 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcSixCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcSevenCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 7 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcSevenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcEightCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 8 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcEightCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcNineCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 9 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcNineCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcTenCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 10 Matches Commision Controller'),
                    Divider(),
                    TextFormField(
                      controller: _mcTenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcElevenCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 11 Matches Commision'),
                    Divider(),
                    TextFormField(
                      controller: _mcElevenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TransactionsTab extends StatefulWidget {
  const TransactionsTab({super.key});

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: kOnPrimaryContainer,
              borderRadius: BorderRadius.circular(10)),
          child: view(),
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
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                // labelText: 'Search',
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: listTitleText('Date.'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Transfer In'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Transfer Out'),
              ),
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Commision Amount'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Balance'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Action'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Expanded(
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
          flex: 5,
          child: listText('1.1.2024'),
        ),
        Expanded(
          flex: 5,
          child: listText('100000'),
        ),
        Expanded(
          flex: 5,
          child: listText('50000'),
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        Expanded(
          flex: 5,
          child: listText('15000'),
        ),
        Expanded(
          flex: 5,
          child: listText('500000'),
        ),
        Expanded(
          flex: 5,
          child: listText('Action'),
        ),
      ],
    );
  }
}
