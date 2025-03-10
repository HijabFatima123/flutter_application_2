import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Changed from teal to indigo
        scaffoldBackgroundColor: Colors.indigo[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const StudentDataScreen(),
    );
  }
}

class StudentDataScreen extends StatefulWidget {
  const StudentDataScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudentDataScreenState createState() => _StudentDataScreenState();
}

class _StudentDataScreenState extends State<StudentDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> students =
      []; // List to store multiple students
  String name = '', rollNumber = '', contact = '', course = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Student Data'), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Student Name', (value) => name = value),
                  _buildTextField('Roll Number', (value) => rollNumber = value),
                  _buildTextField('Contact Number', (value) => contact = value,
                      keyboardType: TextInputType.phone),
                  _buildTextField('Course Name', (value) => course = value),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          students.add({
                            'name': name,
                            'rollNumber': rollNumber,
                            'contact': contact,
                            'course': course,
                          });
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Data Saved Successfully')),
                        );
                      }
                    },
                    child: const Text('Save Data'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(),
                  columns: ['Name', 'Roll No', 'Contact', 'Course']
                      .map((title) => DataColumn(
                          label: Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))))
                      .toList(),
                  rows: students
                      .map(
                        (student) => DataRow(
                          cells: [
                            DataCell(Text(student['name']!)),
                            DataCell(Text(student['rollNumber']!)),
                            DataCell(Text(student['contact']!)),
                            DataCell(Text(student['course']!)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalculatorScreen()),
                );
              },
              child: const Text('Go to Calculator'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)), // Rounded input fields
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double num1 = 0, num2 = 0, result = 0;

  void calculate(String op) {
    setState(() {
      switch (op) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          result = num2 != 0 ? num1 / num2 : 0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Calculator'), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNumberField('Enter first number',
                (value) => num1 = double.tryParse(value) ?? 0),
            _buildNumberField('Enter second number',
                (value) => num2 = double.tryParse(value) ?? 0),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: ['+', '-', '*', '/']
                  .map((op) => ElevatedButton(
                        onPressed: () => calculate(op),
                        child: Text(op),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Result: $result',
                style: const TextStyle(fontSize: 24, color: Colors.indigo)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Student Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)), // Rounded input fields
        ),
        onChanged: onChanged,
      ),
    );
  }
}
