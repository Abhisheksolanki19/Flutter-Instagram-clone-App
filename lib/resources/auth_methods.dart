import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_app/model/users.dart' as userModel;
import 'package:flutter_instagram_app/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<userModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return userModel.User.fromSnap(snap);
  }

  //SignUp User
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      Uint8List? file}) async {
    String res = "Some error occurred";

    if (file == null) {
      return res = "Please chosse profile image.";
    }

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //Register User
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        print(userCredential.user!.uid);
        //Add user to our database

        userModel.User user = userModel.User(
            username: username,
            email: email,
            uid: userCredential.user!.uid,
            bio: bio,
            followers: [],
            following: [],
            phototUrl: photoUrl);

        //Using this method UsersId and docId would be same
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        //Using this method UsersId and docId would be different
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': userCredential.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = "success";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'weak-password':
          return res = 'The password provided is too weak.';
        case 'email-already-in-use':
          return res = 'The account already exists for that email.';
      }
      // return res = 'Unexpected firebase error, Please try again.';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //Logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return res = 'Invalid email address.';
        case 'wrong-password':
          return res = 'Wrong password.';
        case 'user-not-found':
          return res = 'No user corresponding to the given email address.';
        case 'user-disabled':
          return res = 'This user has been disabled.';
        case 'too-many-requests':
          return res = 'Too many attempts to sign in as this user.';
      }
      // return res = 'Unexpected firebase error, Please try again.';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
