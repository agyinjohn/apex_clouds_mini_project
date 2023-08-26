import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../screens/comments_screen.dart';
import '../utils/colors.dart';
import '../utils/pick_image_method.dart';
import '../utils/post_method.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({required this.snap, super.key});
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
  }

  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: mobileBacgroundColor,
                    backgroundImage: NetworkImage(widget.snap['profileUrl']),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15,),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'] == user!.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                              onTap: () {
                                                FireStoreMethods().deletePost(
                                                    widget.snap['postId']);
                                                    Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ));
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().postLikes(
                  likes: widget.snap['likes'],
                  postId: widget.snap['postId'],
                  uid: user.uid);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              Container(   
                margin: const EdgeInsets.all(1),
                height: MediaQuery.of(context).size.height * 0.45,   //
                
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.snap['photoUrl'],
                  placeholder: (context, url) => const  SpinKitThreeBounce(
                    size: 50.0,
                    color: Colors.white,
                  ),
                  errorWidget: (context, url, error) => const SpinKitSpinningLines(color: Colors.white),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  duration: const Duration(milliseconds: 400),
                  child: const Icon(
                    Icons.favorite,
                    color: primaryColor,
                    size: 100,
                  ),
                ),
              )
            ]),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                isSmallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().postLikes(
                        likes: widget.snap['likes'],
                        postId: widget.snap['postId'],
                        uid: user.uid);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        )
                      : const Icon(Icons.favorite_outline),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CommentScreen(
                              postId: widget.snap['postId'],
                            )),
                  );
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () async{
                  // final url = Uri.parse(widget.snap['photoUrl']);
                  // final response = await http.get(url);
                  // final bytes = response.bodyBytes;
                  // final temp = await getTemporaryDirectory();
                  // final path = '${temp.path}/image.png';
                  // File(path).writeAsBytesSync(bytes);
                  // // ignore: deprecated_member_use
                  // await Share.shareFiles([path],text: 'Shared from apex clouds');
                },
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      showSnackBarAction(context, 'This will save to your device');
                    },
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      // ignore: deprecated_member_use
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    // ignore: deprecated_member_use
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,),
                          ),
                          TextSpan(
                            text: '  ${widget.snap['description']}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentScreen(postId: widget.snap['postId'])));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: 
                     StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.snap['postId'])
                            .collection('comments')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                            'View all  comments',
                            style:  TextStyle(color: secondaryColor),
                          );
                          }
                          return Text(
                            'View all ${snapshot.data!.docs.length} comments',
                            style: const TextStyle(color: secondaryColor),
                          );
                        }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
