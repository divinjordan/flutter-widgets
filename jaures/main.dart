import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:geolocation/geolocation.dart';

import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:flutter_complete_guide/screens/MainPage.dart';
import 'package:flutter_complete_guide/screens/SecondPage.dart';
//import 'package:flutter_complete_guide/screens/MainPage.dart';
import 'package:flutter_complete_guide/screens/test.dart';
import 'package:flutter_complete_guide/widgets/pickers/MyImagePicker.dart';
import 'package:flutter_complete_guide/screens/signin_page.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool USE_FIRESTORE_EMULATOR = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //
      title: 'geoApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      /*
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return ChatScreen();
                    //home: MainPage(),
                  }
                  return AuthScreen();
                }),
      */

      // Declare routes
      routes: {
        // Main initial route
        '/': (context) => MainPage(),
        // Second route
        MainPage.routeName: (context) => MainPage(),
        SecondPage.routeName: (context) => SecondPage(),
        AuthScreen.routeName: (context) => AuthScreen(),
        ChatScreen.routeName: (context) => ChatScreen(),
        MyImagePicker.routeName: (context) => MyImagePicker(),
        AuthExampleApp.routeName: (context) => AuthExampleApp(),
        SignInPage.routeName: (context) => SignInPage(),
      },

      initialRoute: '/',
    );
  }
}
