import 'package:flutter/material.dart';

import '../../../classes/restaurant.dart';
import '../../../http/setup/tables/tableManagement.dart';

class TableManager extends StatefulWidget {
  final Restaurant restaurant;

  const TableManager({super.key, required this.restaurant});

  @override
  State<TableManager> createState() => _TableManagerState();
}

class _TableManagerState extends State<TableManager> {
  // Variables for form input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  String _selectedRegion = 'North';

  List<DataRow> tableRows = [];

  @override
  void dispose() {
    _nameController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadInitialTables(); // Load initial tables
  }

  Future<void> _loadInitialTables() async {
    final initialTables = await _allTables();
    setState(() {
      tableRows = initialTables;
    });
  }

  Future<void> _addNewRestaurant(
      String tableName, String seats, String region) async {
    final response = await createTable(
      widget.restaurant.backendAddress,
      tableName,
      seats,
      region,
    );

    if (response == 401) {
      _showDialog(
        title: 'Invalid credentials!',
        content: 'Please contact your personal support',
      );
    } else if (response == 409) {
      _showDialog(
        title: 'Table already exists',
        content: 'The table already exists in the database',
      );
    } else if (response == 400) {
      _showDialog(
        title: 'Invalid input!',
        content: 'The table name, seats, and region must not be empty',
      );
    } else {
      _nameController.clear();
      _seatsController.clear();
      _selectedRegion = 'North';
      _showDialog(
        title: 'Success',
        content: 'Table created successfully',
      );
    }
  }

  void _showDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Management"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Table Manager",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text("Table Name")),
                DataColumn(label: Text("Seats")),
                DataColumn(label: Text("Region")),
                DataColumn(label: Text("Status")),
              ],
              rows: tableRows,
            ),
            const SizedBox(height: 20), // Spacing before the form

            // New Table Form
            Text(
              "Add New Table",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),

            // Name Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Table Name'),
            ),
            const SizedBox(height: 10),

            // Seats Input
            TextField(
              controller: _seatsController,
              decoration: const InputDecoration(labelText: 'Seats (Number)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Region Dropdown
            DropdownButton<String>(
              value: _selectedRegion,
              items: <String>['North', 'East', 'South', 'West']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRegion = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Add Table Button
            ElevatedButton(
              onPressed: () {
                _addNewRestaurant(
                  _nameController.text,
                  _seatsController.text,
                  _selectedRegion,
                );
              },
              child: const Text('Add Table'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<DataRow>> _allTables() async {
  return [
    const DataRow(cells: [
      DataCell(Text('Table 1')),
      DataCell(Text('4')),
      DataCell(Text('North')),
      DataCell(Text('Available')),
    ]),
    const DataRow(cells: [
      DataCell(Text('Table 2')),
      DataCell(Text('2')),
      DataCell(Text('East')),
      DataCell(Text('Occupied')),
    ]),
  ];
}
