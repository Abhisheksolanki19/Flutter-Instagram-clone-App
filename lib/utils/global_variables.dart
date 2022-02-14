import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_app/screens/add_post_screen.dart';
import 'package:flutter_instagram_app/screens/profile_screen.dart';

import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  const Text("Notifications"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];
