import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:flutter_complete_guide/screens/SecondPage.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:flutter_complete_guide/widgets/saveBD/utilisateur.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/home';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.hasData) {
          final userDatasRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.uid)
              //.withConverter<Utilisateur>(
              //fromFirestore: (snapshots, _) => Utilisateur.fromJson(snapshots.data()),
              //toFirestore: (user, _) => user.toJson(),
              //)
              ;
          CollectionReference user = FirebaseFirestore.instance.collection('users');
/*
        // Add from here
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          snapshot.docs.forEach((document) {
            _guestBookMessages.add(
              GuestBookMessage(
                name: document.data()['name'],
                message: document.data()['text'],
              ),
            );
          });
          notifyListeners();
        });
        // to here.
              */
          //final movies = userDatasRef.get();
          var photo;
          if (_auth.currentUser.photoURL.toString().trim() != null) {
            print("photo load non null");
            print(_auth.currentUser.photoURL.toString().trim());
            photo = _auth.currentUser.photoURL.toString().trim();
          } else
            photo = 'https://firebasestorage.googleapis.com/v0/b/tristanauthcrud.appspot.com/o/user_image%2FEladGeorgette.jpg?alt=media&token=62858d04-5631-415c-9c53-83f5e7841e66';

          return Scaffold(
            //_auth.
            appBar: AppBar(
              title: FutureBuilder<DocumentSnapshot>(
                future: user.doc(_auth.currentUser.uid).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (!snapshot.hasData && !snapshot.data.exists) {
                    return Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                    return Text("Bienvenue : ${data['username']}  ${data['email']}");
                  }
                  return Text("loading");
                },
              ),
            ),
            drawer: MainDrawer(),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () => {},
                          splashColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(photo),
                          ),
                        ),

                        //inserer dynamiquement apres !!!!
                        Text("email : " + _auth.currentUser.email.toString()),
                        //Text("phoneNumber : " + _auth.currentUser.phoneNumber.toString()),
                        //Text("photoURL : " + _auth.currentUser.photoURL.toString() != null ? "good" : ""),
                        //Text("providerData : " + _auth.currentUser.providerData.toString()),
                        Text("uid : " + _auth.currentUser.uid.toString()),
                        FutureBuilder<DocumentSnapshot>(
                          future: user.doc(_auth.currentUser.uid).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (!snapshot.hasData && !snapshot.data.exists) {
                              return Text("Document does not exist");
                            }

                            if (snapshot.connectionState == ConnectionState.done) {
                              Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                              return Text("displayName : ${data['username']}");
                              //Text("displayName : " + _auth.currentUser.displayName.toString()),
                            }
                            return Text("loading");
                          },
                        ),
                      ],
                    ),
                    // Navigate using declared route name
                  ],
                ),
              ),
            ),
          );
        }
        return AuthScreen();
      });
}
