import 'package:firebase_database/firebase_database.dart';

class PSU_User {
  String key;
  String _userID;
  String _name;
  String _email;

  PSU_User(this._userID, this._name, this._email);
// PSU_User.fromSnapShot(DataSnapshot snapshot):
//     key = snapshot.key,
//     _userID=snapshot.value["UID"],
//       _name = snapshot.value["name"],
//       _email= snapshot.value["email"];

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  @override
  String toString() {
    return 'PSU_User{_userID: $_userID, _name: $_name, _email: $_email}';
  }
}
