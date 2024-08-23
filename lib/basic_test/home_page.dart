// ignore_for_file: library_private_types_in_public_api

import 'package:db_sqflite/basic_test/DatabaseHelper%20.dart';
import 'package:flutter/material.dart';

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  _NotesAppState createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    List<Map<String, dynamic>> notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _createOrUpdateNote({Map<String, dynamic>? note}) async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (note == null) {
      await _dbHelper.insertNote({'title': title, 'description': description});
    } else {
      await _dbHelper.updateNote(
          {'id': note['id'], 'title': title, 'description': description});
    }

    _titleController.clear();
    _descriptionController.clear();
    _fetchNotes();
  }

  void _deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _fetchNotes();
  }

  void update(Map<String, dynamic> note) {
    _titleController.text = note['title'];
    _descriptionController.text = note['description'];
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes App')),
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
          ElevatedButton(
            onPressed: () {
              if (_titleController.text != "" && _descriptionController.text != "") {
            return    _createOrUpdateNote();
              }else{
               showDialog(context: context, builder: (context) {
                return const AlertDialog( 
                  title: Text("لا يمكن الاضافة "),
                );
               },);
              }
            },
            child: const Text('Add Note'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> note = _notes[index];
                return ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['description']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(note['id']),
                  ),
                  onTap: () {
                    update(note);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
