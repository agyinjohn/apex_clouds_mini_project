import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/pick_image_method.dart';
import '../utils/post_method.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
   TextEditingController _descriptioncontroller = TextEditingController();
  Uint8List? _file;
  bool isLoading = false;
  @override
  void dispose() {
    _descriptioncontroller.dispose();
    super.dispose();
  }

  _postImage(String profileUrl, String uid, String username) async {
    String result = 'An error occured';
    setState(() {
      isLoading = true;
    });
    try {
      String result = await FireStoreMethods().upLoadPost(
          _descriptioncontroller.text.trim(),
          _file!,
          uid,
          username,
          profileUrl);

      if (result == 'Successful') {
        // ignore: use_build_context_synchronously
        showSnackBarAction(context, '✔   Posted');
        setState(() {
          isLoading = false;
        });
        clealPost();
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBarAction(context, result);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(16),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List? file = await pickProfileImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(16),
            child: const Text('Pick image from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List? file = await pickProfileImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(16),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  clealPost() {
    setState(() {
      _descriptioncontroller.text  = '';
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    Size size = MediaQuery.of(context).size;
    return _file == null
        ? Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBacgroundColor,
            centerTitle: true,
            title:  Image.asset(
                'assets/apex1.png',
                height: 120,
                width: 250,
              ),
          ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.10,),
               const Center(child: Text('Select an option to  post', style: TextStyle(color: Colors.white, fontSize: 20),),),
              SizedBox(height: size.height * 0.10,),
             Center(
               child: Container(
                 
                width: size.width * 0.70,
                height: size.height * 0.30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                InkWell(
                  onTap: () async{
                    Uint8List? file = await pickProfileImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      color: webBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      
                      children: const[
                       Icon(Icons.camera), 
                       SizedBox(width: 20,),
                       Text('Take a picture'),
                               
                    ],),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    Uint8List? file = await pickProfileImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
                  },
                  child: Container(
                    
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: webBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                       Icon(Icons.photo_camera_back_outlined), 
                       SizedBox(width: 20,),
                       Text('Pick from gallery'),
                               
                    ],),
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                    color: webBackgroundColor,
                    borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const[
                      Icon(Icons.video_chat), 
                       SizedBox(width: 20,),
                       Text('Pick a video'),
                               
                    ],),
                  ),
                )
               ],),),
             )
            ]),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBacgroundColor,
              leading: IconButton(
                onPressed: clealPost,
                icon: const Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => _postImage(
                    user!.photoUrl,
                    user.uid,
                    user.username,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [Column(
                  children: [
                     Container(
                      width: size.width,
                      height: size.height * 0.60,
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: MemoryImage(_file!),
                           fit: BoxFit.fill,
                           alignment: FractionalOffset.topCenter,
                         ),
                       ),
                     ),
                     SizedBox(height: size.height *  0.10,),
                    TextField(
                      
                      controller: _descriptioncontroller,
                      decoration: const InputDecoration(
                        filled: true,
                        prefixIcon: Icon(Icons.emoji_emotions),
                        focusedBorder: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        hintText: 'Write a caption......',
                        border: InputBorder.none,
                      ),
                      // minLines: 1,
                      // maxLines: 8,
                    ),
                  ],
                ),
            if(isLoading)
                Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black54,
                  child: SpinKitThreeBounce(color: Colors.white,size: 50.0, ),)
                ]
              ),
            ),
          );
  }
}
