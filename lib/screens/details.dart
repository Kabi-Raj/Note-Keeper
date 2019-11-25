import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/database.dart/databasehelper.dart';
import 'package:note_keeper/model/note.dart';

class Details extends StatefulWidget {
  final Note note;
  final String appBar;
  final Function fetchNoteData;

  Details(this.note, this.appBar, this.fetchNoteData);
  @override
  _DetailsState createState() => _DetailsState(note, appBar, fetchNoteData);
}

class _DetailsState extends State<Details> {
  Note note;
  String appBar;
  Function fetchNoteData;
  _DetailsState(this.note, this.appBar, this.fetchNoteData);
  DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _date = '', _time = '';

  Widget _buildTitleForm() {
    return TextFormField(
      cursorWidth: 4.0,
      cursorColor: Theme.of(context).accentColor,
      maxLines: 1,
      validator: (String value) {
        if (value.isEmpty || value.length < 4) {
          return 'Empty title or less than 5 characters';
        }
      },
      initialValue: note.title,
      onSaved: (title) {
        note.title = title;
      },
      decoration: InputDecoration(
        hintText: 'Enter Note title',
      ),
    );
  }

  Widget _buildDescriptionForm() {
    return TextFormField(
      cursorWidth: 4.0,
      cursorColor: Theme.of(context).accentColor,
      maxLines: 4,
      initialValue: note.description,
      onSaved: (desc) {
        note.description = desc;
      },
      decoration: InputDecoration(
        hintText: 'Enter Note Description',
      ),
    );
  }

  Widget _buildSaveBtn() {
    return FlatButton(
      child: Text(
        'Save',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      ),
      onPressed: () {
        setState(() {
          _formKey.currentState.save();
          if (appBar == 'Add Note' &&
              _formKey.currentState.validate() &&
              _date != '' &&
              _time != '') {
            note.completionDate = _date;
            note.completionTime = _time;
            note.id = DateTime.now().toString();
            note.date = DateFormat.jm().format(DateTime.now()).toString();
            databaseHelper.insertNote(note);
            fetchNoteData();
          } else {
            databaseHelper.updateNote(note);
            fetchNoteData();
          }
        });
      },
    );
  }

  Widget _buildDatePicker() {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        size: 30.0,
      ),
      onPressed: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime.now(), onConfirm: (DateTime date) {
          setState(() {
            _date = DateFormat.Md().format(date);
          });
        }, onChanged: (DateTime date) {
          setState(() {
            _date = DateFormat.Md().format(date);
          });
        },
            theme: DatePickerTheme(
                itemStyle: TextStyle(),
                backgroundColor: Theme.of(context).primaryColor,
                doneStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.9),
                cancelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.9)));
      },
    );
  }

  Widget _buildTimePicker() {
    return IconButton(
      icon: Icon(
        Icons.watch_later,
        size: 30.0,
      ),
      onPressed: () {
        DatePicker.showTimePicker(context, showTitleActions: true,
            onConfirm: (DateTime time) {
          setState(() {
            _time = DateFormat.jm().format(time);
          });
        }, onChanged: (DateTime time) {
          setState(() {
            _time = DateFormat.jm().format(time);
          });
        },
            theme: DatePickerTheme(
                backgroundColor: Theme.of(context).primaryColor,
                doneStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.9),
                cancelStyle: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.9)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitleForm(),
                SizedBox(height: 10.0),
                _buildDescriptionForm(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        'Pick Date: ${appBar == 'Edit Note' ? note.completionDate : _date}'),
                    SizedBox(width: 5.0),
                    _buildDatePicker(),
                  ],
                ),
                SizedBox(width: 10.0),
                Divider(thickness: 1.0, color: Colors.black38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        'Pick Time: ${appBar == 'Edit Note' ? note.completionTime : _time}'),
                    SizedBox(width: 10.0),
                    _buildTimePicker()
                  ],
                )
              ],
            ),
            Divider(thickness: 1.0, color: Colors.black38),
            _buildSaveBtn(),
          ],
        ),
      ),
    );
  }
}
