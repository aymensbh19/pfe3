import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';



FirebaseAuth firebaseAuth=FirebaseAuth.instance;
FirebaseUser firebaseUser;
final storage=FirebaseStorage.instance.ref();
final StorageReference storage_users=storage.child("user");
GoogleSignIn googleSignIn;
DocumentReference user;
final firestore =Firestore.instance;
DocumentSnapshot userDocument;

