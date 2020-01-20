class Note {
  String _id;
  String _title;
  String _descriptoin;
  String _date;
  String _completionDate;
  String _completionTime;

  Note(this._id, this._title, this._date, this._completionDate,
      this._completionTime,
      [this._descriptoin]);

  String get id => this._id;
  String get title => this._title;
  String get description => this._descriptoin;
  String get date => this._date;
  String get completionDate => this._completionDate;
  String get completionTime => this._completionTime;

  set id(String id) => this._id = id;
  set title(String title) => this._title = title;
  set description(String desc) => this._descriptoin = desc;
  set date(String date) => this._date = date;
  set completionDate(String compDate) => this._completionDate = compDate;
  set completionTime(String compTime) => this._completionTime = compTime;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this._id;
    map['title'] = this._title;
    map['description'] = this._descriptoin;
    map['date'] = this._date;
    map['completionDate'] = this._completionDate;
    map['completionTime'] = this._completionTime;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._descriptoin = map['description'];
    this._date = map['date'];
    this._completionDate = map['completionDate'];
    this._completionTime = map['completionTime'];
  }
}
