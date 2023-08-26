import 'package:apex_clouds/screens/password_reset_screen.dart';
import 'package:apex_clouds/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../responsive/responsive_layout_screen.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/pick_image_method.dart';
import '../utils/sign_up_method.dart';
import '../widgets/text_field.dart';
import '../screens/web_screen.dart';
import '../screens/mobile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  bool isloading = false;

  logUserIn() async {
    if(emailTextEditingController.text.trim().isNotEmpty && passwordTextEditingController.text.isNotEmpty){
      try {
      setState(() {
        isloading = true;
      });
      final result = await Authentication().loginUser(
          passwordTextEditingController.text.trim(),
          emailTextEditingController.text.trim());
    
      if(result == 'Successful'){
        // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => const ResponsiveScreen(
              mobileScreen: MobileScreen(), webScreen: WebScreen())), (route) => false);
      }else{
        // ignore: use_build_context_synchronously
        showSnackBarAction(context, result);
        setState(() {
        isloading = false;
      });
      }
   
    } catch (err) {
      setState(() {
        isloading = false;
      });
      showSnackBarAction(context, err.toString());
    }
    }else{
      showSnackBarAction(context, 'Please provide all fields');
    }
    
  }

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: size.width,
        height: size.height,
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
      
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // ignore: deprecated_member_use
              // SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor),
              Image.asset(
                'assets/apex1.png',
                height: 180,
              ),
              const Text('Welcome, Sign In Here', style:  TextStyle(fontSize: 25, color: Colors.white),),
              const SizedBox(
                height: 30,
              ),
              TextFieldInput(
                  textEditingController: emailTextEditingController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Your email address'),
              const SizedBox(
                height: 25,
              ),
              TextFieldInput(
                textEditingController: passwordTextEditingController,
                textInputType: TextInputType.text,
                hintText: 'Enter password',
                isPass: true,
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: logUserIn,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: isloading
                      ? const  SpinKitThreeBounce(
                    size: 50.0,
                    color: Colors.white,
                  )
                      : const Text('Log In'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(alignment: Alignment.topRight,child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PasswordResetScreen()));
              }, child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),)),),
           SizedBox(height: size.height* 0.1,),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: const Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text('Sign Up',style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17, color: Colors.blue),),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
