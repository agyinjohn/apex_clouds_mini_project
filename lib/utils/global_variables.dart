import 'package:firebase_auth/firebase_auth.dart';


import '../screens/add_post_screen.dart';
import 'package:flutter/material.dart';

import '../screens/favour_screen.dart';
import '../screens/feed_page.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homePageItems = [
  const FeedPage(),
  const SearchScreen(),
  const AddPostScreen(),
   const FovouriteScreen() ,
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
