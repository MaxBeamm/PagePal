import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {

  UserInfo();

  String uuid = '';
  String firstName = "Guest";
  String lastName = "User";
  String email = "";
  bool _signedIn = false;

  bool getSignedIn() {
    return _signedIn;
  }

  void setSignedIn(bool signedIn) {
    _signedIn = signedIn;
  }

  String getUuid() {
    return uuid;
  }

  void init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        signedOut();
        _signedIn = false;
      } else {
        print('User ${user.uid} is signed in!');
        populateFromDatabase(user.uid).catchError((Object error) {
          // Older accounts may not have an associated profile document.
          print('Could not load profile: $error');
        });
        _signedIn = true;
      }
    });
  }

  Future<void> populateFromDatabase(String uuid) async {
    CollectionReference profilesCollection = FirebaseFirestore.instance.collection('profiles');
    await profilesCollection.doc(uuid).get().then((value) {
      final data = value.data() as Map<String, dynamic>?;
      this.uuid = uuid;
      firstName = data?['FirstName'] as String? ?? 'Guest';
      lastName = data?['LastName'] as String? ?? 'User';
      email = data?['Email'] as String? ?? FirebaseAuth.instance.currentUser?.email ?? '';
    });
  }

  void signedOut() {
    // Runs when the authentication state listener finds the user has been signed out
    uuid = '';
    firstName = "Guest";
    lastName = "User";
    email = "";
    _signedIn = false;
  }

}