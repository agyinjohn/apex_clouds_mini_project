import 'dart:typed_data';
import 'package:apex_clouds/utils/storage_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart' as model;

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _storage = FirebaseFirestore.instance;
  static bool isLoading = false;

  Future<model.User> getUserDetails() async {
    DocumentSnapshot snapshot =
        await _storage.collection('users').doc(_auth.currentUser!.uid).get();

    return model.User.fromSnap(snapshot);
  }

  // Sign up method
  Future<String> signUp({
    required String username,
    required String userbio,
    required String email,
    required String password,
    required Uint8List? file,
  }) async {
    String result = 'Some error occured';
    if (userbio.isNotEmpty ||
        username.isNotEmpty ||
        email.isNotEmpty ||
        // file.isNotEmpty ||
        password.isNotEmpty) {
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await ImageStorage()
            .uploadeImageToStorage(file!, false, 'Profilepics');

        model.User user = model.User(
            bio: userbio,
            email: email,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            uid: credential.user!.uid,
            username: username);

        await _storage.collection('users').doc(credential.user!.uid).set(
              user.toJson(),
            );
        result = 'Succesfull Sign up';
      } catch (err) {
        result = err.toString();
        // ignore: avoid_print
        // print('Errrorrr');
        print(err.toString());
      }
    }
    return result;
  }

  Future<String> loginUser(String password, String email) async {
    String result = 'All fields are required';
    if (password.isNotEmpty || email.isNotEmpty) {
      try {
     UserCredential credential =    await _auth.signInWithEmailAndPassword(
            email: email, password: password);
            print(credential.user);
            if(credential.user != null){
            result = 'Successful';
            }
      } catch (err) {
      result = 'error';
        result = err.toString();
        print(err);
      }
    }

    return result;
  }

  signOut() {
    _auth.signOut();
  }
}
