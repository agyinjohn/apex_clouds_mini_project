import 'package:apex_clouds/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/colors.dart';
import '../utils/post_method.dart';
import '../widgets/follow_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = '';

  bool hasRunned = false;
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Build Called');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: webBackgroundColor,
          title: TextFormField(
            controller: searchController,
            onChanged: (value) {
              name = value;
              setState(() {});
            },
            decoration: const InputDecoration(
                filled: true,
                enabledBorder: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search for a user....',
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
              
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              if (name.isEmpty) {
                return InkWell(
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(uid: data['uid']),
                          ),
                        ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage( data['photoUrl']),
                      ),
                      title: Text(
                        data['username'],
                      ),
                      trailing: FirebaseAuth.instance.currentUser!.uid ==
                              snapshot.data!.docs[index]['uid']
                          ? FollowButton(
                              widthI: 100,
                              borderColor: Colors.grey,
                              text: 'View profile',
                              textColor: primaryColor,
                              backgroundColor: mobileBacgroundColor,
                              funtion: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),),);
                              },
                            )
                          : snapshot.data!.docs[index]['followers'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? FollowButton(
                                  widthI: 100,
                                  borderColor: Colors.grey,
                                  text: 'Unfollow',
                                  textColor: primaryColor,
                                  backgroundColor: mobileBacgroundColor,
                                  funtion: () async {
                                    await FireStoreMethods().followingUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        data['uid']);
                                    setState(() {});
                                  },
                                )
                              : FollowButton(
                                  widthI: 100,
                                  borderColor: Colors.grey,
                                  text: 'Follow',
                                  textColor: primaryColor,
                                  backgroundColor: mobileBacgroundColor,
                                  funtion: () async {
                                    await FireStoreMethods().followingUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      data['uid'],
                                    );
                                    setState(() {});
                                  },
                                ),
                    ));
              }
             else if (data['username']
                  .toString()
                  .toLowerCase()
                  .contains(name.toLowerCase())) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]['photoUrl']),
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['username'],
                  ),
                  trailing: FirebaseAuth.instance.currentUser!.uid ==
                          snapshot.data!.docs[index]['uid']
                      ? FollowButton(
                          widthI: 100,
                          borderColor: Colors.grey,
                          text: 'View profile',
                          textColor: primaryColor,
                          backgroundColor: mobileBacgroundColor,
                          funtion: () async {},
                        )
                      : snapshot.data!.docs[index]['followers']
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? FollowButton(
                              widthI: 100,
                              borderColor: Colors.grey,
                              text: 'Unfollow',
                              textColor: primaryColor,
                              backgroundColor: mobileBacgroundColor,
                              funtion: () async {
                                await FireStoreMethods().followingUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    snapshot.data!.docs[index]['uid']);
                                setState(() {});
                              },
                            )
                          : FollowButton(
                              widthI: 100,
                              borderColor: Colors.grey,
                              text: 'Follow',
                              textColor: primaryColor,
                              backgroundColor: mobileBacgroundColor,
                              funtion: () async {
                                await FireStoreMethods().followingUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  snapshot.data!.docs[index]['uid'],
                                );
                                setState(() {});
                              },
                            ),
                );
              }
              return Container();
            });
          },
        ));
  }
}
