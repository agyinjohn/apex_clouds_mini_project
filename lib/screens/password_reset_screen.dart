// ignore_for_file: use_build_context_synchronously

import 'package:apex_clouds/screens/login_screen.dart';
import 'package:apex_clouds/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/pick_image_method.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  bool isLoading = false;
  final TextEditingController emailTextController = TextEditingController();
    forgotPassword()async{
      FirebaseAuth auth = FirebaseAuth.instance;
      if(emailTextController.text.trim().isNotEmpty){
        try{
          setState(() {
            isLoading = true;
          });
   await  auth.sendPasswordResetEmail(email: emailTextController.text.trim());
   showSnackBarAction(context, 'Email was sent successfully');
     setState(() {
            isLoading = false;
          });
   
   Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
   
  }catch(err){
     setState(() {
            isLoading = false;
          });
   showSnackBarAction(context, err.toString());
  }
      }else{
        showSnackBarAction(context, 'Please provide an email address');
      }
  

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('Reset Password'), centerTitle: true, elevation: 0, ),
      body: 
      
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           
           Image.asset(
              'assets/apex1.png',
              height: 120,
              width: 250,
            ),
        const SizedBox(height: 10,),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 25),
           child: TextFieldInput(hintText: 'Please enter your email', textEditingController: emailTextController, textInputType: TextInputType.emailAddress, ),
         ),
      
         const SizedBox(height: 20,),
          Center(child: GestureDetector(
           onTap: forgotPassword,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:25.0),
              child: Container(
              
               height: 50,
               width: double.infinity,
               
               decoration: BoxDecoration(
                 color:Colors.blue,
                 borderRadius: BorderRadius.circular(2)),
               child: isLoading?  const Center(child: SpinKitThreeBounce(
                    size: 50.0,
                    color: Colors.white,
                  )) : const Center(child: Text('Reset Password',style: TextStyle(color:  Colors.white, fontSize: 20, fontWeight: FontWeight.bold),) ) ,),
            ),
          ),)
       ],),
      );;
  }
}