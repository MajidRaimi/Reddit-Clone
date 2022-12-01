import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redit_tutorial/core/providers/firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  // ? Depends on your project
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  // ? You Can't Access private variables in constructor so you must do it this way
  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  void signInWithGoogle() async {
    try {
      // ? get the account from google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // ? get the authentication from the account
      final googleAuth = await googleUser?.authentication;

      // ? create the credential from your account
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // ? sign in with the credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print(userCredential.user?.email);
    } catch (E) {
      print(E);
    }
  }
}
