import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_complete_guide/widgets/auth/auth_form.dart';
import 'package:flutter_complete_guide/widgets/saveBD/utilisateur.dart';

/*
final utilisateursRef = FirebaseFirestore.instance.collection('users').withConverter<Utilisateur>(
      fromFirestore: (snapshots, _) => Utilisateur.fromJson(snapshots.data()),
      toFirestore: (utilisateur, _) => utilisateur.toJson(),
    );
*/
class AuthScreen extends StatefulWidget {
  static const routeName = '/authentification';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _auth = FirebaseAuth.instance;
  var _isLoading = false;
  firebase_storage.FirebaseStorage storage;
  FirebaseApp secondaryApp;
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    print("initializeFlutterFire()");
    setState(() {
      _isLoading = true;
    });
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      print("Firebase.initializeApp()");
      //secondaryApp = Firebase.app('SecondaryApp');
      //print("Firebase.app('SecondaryApp')");

      setState(() {
        print("initialisation reussie!");
        _isLoading = false;
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        print("Erreur d'initialisation!");
        _error = true;
      });
    }
  }

  @override
  void initState() {
    print("initState() ");
    initializeFlutterFire();
    storage = firebase_storage.FirebaseStorage.instance;
    super.initState();
  }

  Future<void> signOut() async {
    //await FirebaseAuth.instance.signOut();
    await _auth.signOut();
  }

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref("user_image").listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult; //Future<UserCredential>
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final User user = authResult.user;
        setState(() {
          _isLoading = true;
          _auth = FirebaseAuth.instance;
        });
        if (user != null) {
          print("Welcome!");
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text("Welcome ! Connexion établi avec succés sur le serveur !"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 6, milliseconds: 500),
            ),
          );
        } else {
          print("Connexion echoue!");
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text("Désolé la connexion n'a pas fonctionner veillez recommencer...Verifiez vos données et la connexion internet."),
              backgroundColor: Theme.of(ctx).errorColor,
              duration: Duration(seconds: 6, milliseconds: 500),
            ),
          );
        }
      } else {
        /* FirebaseAuth */
        authResult = await _auth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((userr) async {
          //UserUpdateInfo updateInfo = UserUpdateInfo();
          //updateInfo.displayName = username;
          //updateInfo.photoURL = 'https://firebasestorage.googleapis.com/v0/b/tristanauthcrud.appspot.com/o/user_image%2FEladGeorgette.jpg?alt=media&token=62858d04-5631-415c-9c53-83f5e7841e66';
          //await user.updateProfile(updateInfo);
          //await user.reload();
          var updatedUser = await _auth.currentUser;
          print('USERNAME IS: ${updatedUser.displayName}');

          print("Enregistrer!");
          final User user = await _auth.currentUser; //authResult.user;
          setState(() {
            print("setState(()");
            _auth = FirebaseAuth.instance;
            storage = firebase_storage.FirebaseStorage.instance;
            //storage = firebase_storage.FirebaseStorage.instanceFor(app: secondaryApp);
            print("state set!");
          });
          if (user != null) {
            print("Utilisateur non vide!");
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text("Compte crée avec succés !!!! Merci"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 6, milliseconds: 500),
              ),
            );
          } else {
            print("Utilisateur vide non créer!");
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text("Erreur de création de compte !!! Verifiez vos données et la connexion internet."),
                backgroundColor: Theme.of(ctx).errorColor,
                //duration: Duration(seconds: 6, milliseconds: 500),
              ),
            );
          }

          /* FirebaseStorage */
          var url;

          /*    FirebaseAuth      */
          //await user.updateEmail(email);
          //print("Email update");
          await user.updateDisplayName(username);
          await user.updateProfile(displayName: username);
          print("user name update : " + username);
          if (url != null)
            await user.updatePhotoURL(url.toString());
          else
            await user.updatePhotoURL('https://firebasestorage.googleapis.com/v0/b/tristanauthcrud.appspot.com/o/user_image%2FEladGeorgette.jpg?alt=media&token=62858d04-5631-415c-9c53-83f5e7841e66');

          await user.updateProfile(photoURL: 'https://firebasestorage.googleapis.com/v0/b/tristanauthcrud.appspot.com/o/user_image%2FEladGeorgette.jpg?alt=media&token=62858d04-5631-415c-9c53-83f5e7841e66');
          print("photo update");
          String phoneNumber = "+237698203203 ";
          //await authResult.user.updatePhoneNumber(phoneNumber);
          //authResult.user.updatePassword(email);
          /*     Firestore    */
          print("BD FireStore!");
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'userRef': user.uid, //
            'username': username, //user.displayName, //username,
            'email': user.email, //email,
            'image_url': 'https://firebasestorage.googleapis.com/v0/b/tristanauthcrud.appspot.com/o/user_image%2FEladGeorgette.jpg?alt=media&token=62858d04-5631-415c-9c53-83f5e7841e66',
            //user.photoURL.toString(), //url,
            'date': DateTime.now(),
          }).then((_) {
            print("save in BD success!");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Sauvegarder avec succés sur FireStore"),
              duration: Duration(seconds: 3, milliseconds: 500),
            ));
          });
        }).catchError((error) {
          print('Something Went Wrong: ${error.toString()}');
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      print("une erreur de platform a été levé");
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
          duration: Duration(seconds: 6, milliseconds: 500),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print("Erreur levé");
      print(err);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(ctx).errorColor,
          duration: Duration(seconds: 6, milliseconds: 500),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
/*
  firestoreInstance.collection("users").add({
    "name": "john",
    "age": 50,
    "email": "example@example.com",
    "address": {"street": "street 24", "city": "new york"}
  }).then((value) {
    print(value.id);
    firestoreInstance
        .collection("users")
        .doc(value.id)
        .collection("pets")
        .add({"petName": "blacky", "petType": "dog", "petAge": 1});
  });
void _onPressed() {
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).update({
    "name" : "john",
    "age" : 50,
    "email" : "example@example.com",
    "address" : {
      "street" : "street 24",
      "city" : "new york"
    }
  }).then((_) {
    print("success!");
  });
}
        */
