class Note {
  String _id;
  String _title;
  String _descriptoin;
  String _date;
  String _priority;

  Note(this._id, this._title, this._descriptoin, this._date, this._priority);

  String get id => this._id;
  String get title => this._title;
  String get description => this._descriptoin;
  String get date => this._date;
  String get priority => this._priority;

  set id(String id) => this._id = id;
  set title(String title) => this._title = title;
  set description(String desc) => this._descriptoin = desc;
  set date(String date) => this._date = date;
  set priority(String priority) => this._priority = priority;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this._id;
    map['title'] = this._title;
    map['description'] = this._descriptoin;
    map['date'] = this._date;
    map['priority'] = this._priority;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._descriptoin = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}
