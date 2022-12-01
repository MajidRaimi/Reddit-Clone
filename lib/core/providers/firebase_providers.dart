import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ? creating the providers for firebase
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final storageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

// it's not an instance 
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());
