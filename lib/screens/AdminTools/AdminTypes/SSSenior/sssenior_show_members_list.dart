import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SSSeniorShowMembersList extends StatefulWidget {
  static String id = "sssenior_show_members_list";
  const SSSeniorShowMembersList({super.key});

  @override
  State<SSSeniorShowMembersList> createState() =>
      _SSSeniorShowMembersListState();
}

class _SSSeniorShowMembersListState extends State<SSSeniorShowMembersList> {
  List<UserMember> userMember = <UserMember>[];
  late UserMemberDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    userMember = getEmployeeData();
    employeeDataSource = UserMemberDataSource(employeeData: userMember);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
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
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SfDataGrid(
            source: employeeDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'id',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: labelText('ID'))),
              GridColumn(
                  columnName: 'name',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: labelText('Username'))),
              GridColumn(
                  columnName: 'designation',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: labelText('Phone Number'))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: labelText('Salary'))),
            ],
          ),
        ),
      ),
    );
  }

  List<UserMember> getEmployeeData() {
    return [
      UserMember(1, 'James', '09400104050', 20000),
      UserMember(2, 'Kathryn', '0617377609', 30000),
      UserMember(3, 'Lara', '09400104050', 15000),
      UserMember(4, 'Michael', '09792060205', 15000),
      UserMember(5, 'Martin', '0617377609', 15000),
      UserMember(6, 'Newberry', '09400104050', 15000),
      UserMember(7, 'Balnc', '09792060205', 15000),
      UserMember(8, 'Perry', '09400104050', 15000),
      UserMember(9, 'Gable', '09400104050', 15000),
      UserMember(10, 'Grimes', '0617377609', 15000)
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class UserMember {
  /// Creates the employee class with required details.
  UserMember(this.id, this.username, this.phoneNumber, this.units);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String username;

  /// Designation of an employee.
  final String phoneNumber;

  /// Salary of an employee.
  final double units;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class UserMemberDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  UserMemberDataSource({required List<UserMember> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.username),
              DataGridCell<String>(
                  columnName: 'designation', value: e.phoneNumber),
              DataGridCell<double>(columnName: 'salary', value: e.units),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
