import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redit_tutorial/core/failure.dart';
import 'package:redit_tutorial/core/providers/firebase_providers.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/type_defs.dart';
import '../../../model/user_model.dart';

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

  // getter function to the users reference in firestore
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
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

      UserModel userModel;
      // ! check if user is new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        // ? create the user with userModel from the credential
        userModel = UserModel(
          name: userCredential.user?.displayName ?? 'No Name',
          profilePic: userCredential.user?.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );

        // set data with doc = user_uid in firebase with all user information
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        // .first will convert stream to future (will get the first element of the stream)
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(
        userModel,
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  // ! as a stream not future for instance updates
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
