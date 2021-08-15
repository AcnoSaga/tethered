import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  User get currentUser => _firebaseAuth.currentUser;

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String name, String username) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseFirestore
          .collection('accounts')
          .doc(authResult.user.uid)
          .set({
        "description": "Hi! I'm " + name,
        "followers": [],
        "following": [],
        "imageUrl": "",
        "name": name,
        "username": username,
        "works": 0,
      });
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signOutUser() async {
    await _firebaseAuth.signOut();
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  bool isUserLoggedIn() {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  bool isUserVerified() {
    var user = _firebaseAuth.currentUser;
    return user != null && user.emailVerified;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendEmailForVerificationToCurrentUser() async {
    await _firebaseAuth.currentUser.sendEmailVerification();
  }

  Future deleteCurrentUserAccount(bool hasImage) async {
    print('Deleted');
    if (hasImage) {
      await _firebaseStorage
          .ref('accounts/${getCurrentUser().uid}/profile/profile.png')
          .delete();
    }
    (await _firebaseFirestore
            .collection('accounts')
            .doc(getCurrentUser().uid)
            .collection('drafts')
            .get())
        .docs
        .forEach((doc) async {
      await _firebaseStorage
          .ref('accounts/${getCurrentUser().uid}/drafts/${doc.id}.png')
          .delete();
    });
    await _firebaseFirestore
        .collection('accounts')
        .doc(getCurrentUser().uid)
        .delete();
    await _firebaseAuth.currentUser.delete();
  }
}
