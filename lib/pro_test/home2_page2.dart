// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class NotesApp2 extends StatefulWidget {
  const NotesApp2({super.key});

  @override
  _NotesApp2State createState() => _NotesApp2State();
}

class _NotesApp2State extends State<NotesApp2> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Work';
  String _selectedPriority = 'High';

  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    List<Map<String, dynamic>> notes = await _dbHelper.queryAllRows();
    setState(() {
      _notes = notes;
    });
  }

  void _createOrUpdateNote({Map<String, dynamic>? note}) async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (note == null) {
      await _dbHelper.insert({
        'title': title,
        'description': description,
        'category': _selectedCategory,
        'priority': _selectedPriority,
      });
    } else {
      await _dbHelper.update({
        'id': note['id'],
        'title': title,
        'description': description,
        'category': _selectedCategory,
        'priority': _selectedPriority,
      });
    }

    _titleController.clear();
    _descriptionController.clear();
    _fetchNotes();
  }

  void _deleteNote(int id) async {
    await _dbHelper.delete(id);
    _fetchNotes();
  }

  void _searchNotes(String keyword) async {
    List<Map<String, dynamic>> notes = await _dbHelper.searchNotes(keyword);
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notes App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _searchNotes(_searchController.text);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>['Work', 'Personal', 'Others']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedPriority,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
                items: <String>['High', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () => _createOrUpdateNote(),
              child: const Text('Add Note'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> note = _notes[index];
                  return ListTile(
                    title: Text(note['title']),
                    subtitle: Text(
                        '${note['description']} - ${note['category']}'), // OR  (priority)
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _titleController.text =note['title']; // تعبئة الحقل النصي بالعنوان
                              _descriptionController.text = note['description']; // تعبئة الحقل النصي بالوصف
                              _selectedCategory =note['category']; // تعيين الفئة المختارة
                              _selectedPriority =note['priority']; // تعيين الأولوية المختارة
                              // هنا يمكن إضافة منطق التحديث أو عرض واجهة التحرير للملاحظة
                              setState(
                                  () {}); // تحديث واجهة المستخدم لعرض القيم في الحقول النصية
                            }),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNote(note['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
