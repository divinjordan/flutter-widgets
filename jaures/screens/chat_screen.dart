import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';

import 'package:flutter_complete_guide/widgets/chat/messages.dart';
import 'package:flutter_complete_guide/widgets/chat/new_message.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';

  /*
  final Telephony telephony = Telephony.instance;

  List<String> recipents = ["9876543210", "8765432190"];
void _sendSMS(String message, List<String> recipents) async {
  String _result = await sendSMS(message: message, recipients: recipents)
      .catchError((onError) {
    print(onError);
  });
  print(_result);
}
_sendSMS("This is a test message!", recipents);
*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Le Chat'),
                actions: [
                  DropdownButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                        ),
                        value: 'logout',
                      ),
                    ],
                    onChanged: (itemIdentifier) {
                      if (itemIdentifier == 'logout') {
                        FirebaseAuth.instance.signOut();
                      }
                    },
                  ),
                ],
              ),
              body: Container(
                height: 450,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Messages(),
                    ),
                    NewMessage(),
                  ],
                ),
              ),
            );
          }
          return AuthScreen();
        });
  }
}
