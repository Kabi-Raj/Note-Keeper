import 'package:flutter/material.dart';
import 'package:note_keeper/database.dart/databasehelper.dart';
import 'package:note_keeper/model/note.dart';
import 'package:note_keeper/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> noteList = List<Note>();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = true;

  void fetchNoteData() async {
    Database initDB = await _databaseHelper.initializeDatabase();
    if (initDB != null) {
      this.noteList = await _databaseHelper.fetchNotes();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchNoteData();
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.purple,
          title: Text('Note Keeper')),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(40.0)),
                color: Colors.white30),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(40.0)),
            child: noteList.length == 0
                ? Center(
                    child: Container(
                      child: Text(
                        'Empty List',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        semanticsLabel: 'Loding...',
                        backgroundColor: Colors.purple,
                      ))
                    : ListView.builder(
                        itemCount: noteList.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            elevation: 20.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => NoteDetails(
                                                    appBar: 'Edit Note',
                                                    note: noteList[index],
                                                  )));
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
                                          Text(
                                            noteList[index].title,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.9),
                                          ),
                                          Text(noteList[index].date)
                                        ],
                                      ),
                                      Text(noteList[index].description),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _databaseHelper
                                            .deleteNote(noteList[index].id);
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          ),
          Positioned(
            right: 10.0,
            bottom: 10.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetails(
                          appBar: 'Add Note',
                          note: Note("", "", "", "", "High"),
                        )));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadiusDirectional.circular(60.0)),
                child: Icon(
                  Icons.add,
                  size: 40.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
