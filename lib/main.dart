import 'package:apex_clouds/providers/user_provider.dart';
import 'package:apex_clouds/responsive/responsive_layout_screen.dart';
import 'package:apex_clouds/screens/login_screen.dart';
import 'package:apex_clouds/screens/mobile_screen.dart';
import 'package:apex_clouds/screens/web_screen.dart';
import 'package:apex_clouds/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
             apiKey: 'AIzaSyCEGM3GZpgv80XoOnQvGdTDTJO0w9-Ybxo',
    appId: '1:466308218787:web:d1a37a9df1a98589e4e416',
    messagingSenderId: '466308218787',
    projectId: 'apexclouds-ed3df',
    storageBucket: 'apexclouds-ed3df.appspot.com',
    ),);
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBacgroundColor,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshhot) {
              if (snapshhot.connectionState == ConnectionState.active) {
                if (snapshhot.hasData) {
                  return const ResponsiveScreen(
                      mobileScreen: MobileScreen(), webScreen: WebScreen());
                } else if (snapshhot.hasError) {
                  return const Scaffold(
                    body: Center(
                      child: Text("Please an error occured"),
                    ),
                  );
                }
              }
              if (snapshhot.connectionState == ConnectionState.waiting) {
                return const  SpinKitThreeBounce(
                    size: 50.0,
                    color: Colors.white,
                  );
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
