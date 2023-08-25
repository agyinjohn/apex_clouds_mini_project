import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/post_card.dart';

class FovouriteScreen extends StatefulWidget {
  const FovouriteScreen({super.key});

  @override
  State<FovouriteScreen> createState() => _FovouriteScreenState();
}

class _FovouriteScreenState extends State<FovouriteScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBacgroundColor,
        title:
            // ignore: deprecated_member_use
            Image.asset(
          'assets/apex1.png',
          height: 100,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').where('likes', arrayContains: FirebaseAuth.instance.currentUser!.uid ).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
              
                  return PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  );
                });
          }),
    );
  }
}
