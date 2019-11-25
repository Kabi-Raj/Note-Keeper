import 'package:flutter/material.dart';
import 'package:note_keeper/database.dart/databasehelper.dart';
import 'package:note_keeper/model/note.dart';
import 'package:note_keeper/screens/details.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> noteList = List<Note>();
  int _count = 0;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = true;

  void fetchNoteData() async {
    Future<Database> initDB = _databaseHelper.initializeDatabase();
    initDB.then((database) {
      Future<List<Note>> notes = _databaseHelper.fetchNotes();
      notes.then((noteList) {
        setState(() {
          this.noteList = noteList;
          _count = noteList.length;
          _isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    fetchNoteData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Note Keeper')),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0)),
                color: Theme.of(context).backgroundColor),
          ),
          ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50.0),
                topLeft: Radius.circular(50.0)),
            child: noteList.length == 0 && !_isLoading
                ? Center(
                    child: Container(
                      child: Text(
                        'Empty Note',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _count,
                        itemBuilder: (context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        _showAlertDialog(
                                            context,
                                            'Edit Note',
                                            Details(noteList[index],
                                                'Edit Note', fetchNoteData));
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                noteList[index].title,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.9),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                noteList[index].completionDate +
                                                    '/' +
                                                    noteList[index]
                                                        .completionTime,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          noteList[index].description,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(letterSpacing: 0.9),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: IconButton(
                                      //delete a note
                                      onPressed: () {
                                        setState(() {
                                          _showDeleteAlert(
                                              context, noteList[index].id);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Positioned(
              //Raised button to add note
              right: 10.0,
              bottom: 10.0,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                child: Icon(Icons.add),
                elevation: 30.0,
                onPressed: () {
                  _isLoading = true;
                  _showAlertDialog(
                      context,
                      'Add Note',
                      Details(Note('', '', '', '', '', ''), 'Add Note',
                          fetchNoteData));
                },
              )),
        ],
      ),
    );
  }

  _showDeleteAlert(BuildContext contex, String id) {
    showDialog(
        context: context,
        builder: (conntext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text('Are you sure?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  _databaseHelper.deleteNote(id);
                  setState(() {
                    _isLoading = true;
                  });
                  fetchNoteData();
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  _showAlertDialog(BuildContext context, String title, Details details) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(title),
            content: details,
          );
        });
  }
}
