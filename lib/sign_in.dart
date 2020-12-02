import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:string_validator/string_validator.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String id='';
PSU_User logged_in_user;
String type;
Future<PSU_User> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(user.email != null);
    assert(user.displayName != null);
    // Store the retrieved data
    name = user.displayName;
    email = user.email;

    id = email.substring(0, email.indexOf('@'));
    if (isAlpha(email[0])){
      type = "Faculty";
      logged_in_user=new Faculty('','','');
    }else{
      type = "Students";
      logged_in_user=new Student('','','');
    }
    logged_in_user.name=name;
    logged_in_user.email=email;
    logged_in_user.userID=id;

   // logged_in_user.userID
    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');
    
    
    if (!await userExists(logged_in_user.userID)){
      final referenceDb = FirebaseDatabase.instance.reference();
     await referenceDb.child(type).child(logged_in_user.userID).set({
          "name": logged_in_user.name,
          "Email":logged_in_user.email,
          "UID":logged_in_user.userID
      });
    }
    return logged_in_user;
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}
Future<bool> userExists(String id) async{
  final referenceDb = FirebaseDatabase.instance.reference();
  var user;
    user = referenceDb.child(type);
  await user.once().then((DataSnapshot dataSnapshot) {
    var keys = dataSnapshot.value.keys;
    var values = dataSnapshot.value;
    for (var key in keys) {
      if (key == id){
           return true;
      }

    }
  });
  return false;
}