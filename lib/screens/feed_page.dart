import 'package:apex_clouds/utils/pick_image_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/colors.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
            onPressed: () {
              showSnackBarAction(context, 'Not yet implemented');
            },
            icon: const Icon(
              Icons.notification_add,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: SpinKitThreeBounce(color: Colors.white,size: 50,));
            }else if(snapshot.data!.docs.isEmpty){
              return const Center(child: SpinKitThreeBounce(color: Colors.white,size: 50,));
            }else if(snapshot.data == null){
              return const Center(child: SpinKitThreeBounce(color: Colors.white,size: 50,));
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

