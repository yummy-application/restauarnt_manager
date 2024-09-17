import 'package:flutter/material.dart';

class TableManager extends StatefulWidget {
  const TableManager({super.key});

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

  // Dummy function to add a new table (update this as needed)
  void _addNewTable() {
    setState(() {
      tableRows.add(
        DataRow(cells: [
          DataCell(Text(_nameController.text)),
          DataCell(Text(_seatsController.text)),
          DataCell(Text(_selectedRegion)),
          DataCell(const Text('Available')), // Dummy status
        ]),
      );

      // Clear the form after adding
      _nameController.clear();
      _seatsController.clear();
      _selectedRegion = 'North';
    });
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
              onPressed: _addNewTable,
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
    DataRow(cells: [
      DataCell(Text('Table 1')),
      DataCell(Text('4')),
      DataCell(Text('North')),
      DataCell(Text('Available')),
    ]),
    DataRow(cells: [
      DataCell(Text('Table 2')),
      DataCell(Text('2')),
      DataCell(Text('East')),
      DataCell(Text('Occupied')),
    ]),
  ];
}
