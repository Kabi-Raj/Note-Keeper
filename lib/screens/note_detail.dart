import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/database.dart/databasehelper.dart';
import 'package:note_keeper/model/note.dart';

class NoteDetails extends StatefulWidget {
  final Note note;
  final String appBar;
  NoteDetails({this.note, this.appBar});
  @override
  _NoteDetailsState createState() => _NoteDetailsState(note, appBar);
}

class _NoteDetailsState extends State<NoteDetails> {
  final Note note;
  final String appBar;
  //final DatabaseHelper databaseHelper;
  _NoteDetailsState(this.note, this.appBar);
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<String> dropdownmenu = ['High', 'Low'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildPriorityDropdown() {
    return DropdownButton(
      underline: Text(''),
      value: note.priority,
      onChanged: (String value) {
        setState(() {
          note.priority = value;
        });
      },
      items: dropdownmenu.map((menu) {
        return DropdownMenuItem(
          value: menu,
          child: Text(menu),
        );
      }).toList(),
    );
  }

  Widget _buildTitleForm() {
    return TextFormField(
      maxLines: 1,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Empty title or less than 5 characters';
        }
      },
      initialValue: note.title,
      onSaved: (title) {
        note.title = title;
      },
      decoration: InputDecoration(
          labelText: 'Enter Note Title',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
  }

  Widget _buildDescriptionForm() {
    return TextFormField(
      maxLines: 4,
      validator: (String value) {
        if (value.isEmpty || value.length < 3) {
          return 'Empty description or less than 3 characters';
        }
      },
      initialValue: note.description,
      onSaved: (desc) {
        note.description = desc;
      },
      decoration: InputDecoration(
          labelText: 'Enter Note Description',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );
  }

  Widget _buildSaveBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _formKey.currentState.validate();
          _formKey.currentState.save();
          if (appBar == 'Add Note') {
            note.id = DateTime.now().toString();
            note.date = DateFormat.jms().format(DateTime.now()).toString();
            databaseHelper.insertNote(note);
          } else {
            databaseHelper.updateNote(note);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: InkWell(
          splashColor: Colors.red,
          child: Text(
            'Save',
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.blue, width: 2.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(appBar),
          ),
          body: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildPriorityDropdown(),
                        SizedBox(height: 10.0),
                        _buildTitleForm(),
                        SizedBox(height: 10.0),
                        _buildDescriptionForm(),
                        SizedBox(height: 10.0),
                      ],
                    ),
                    _buildSaveBtn(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
