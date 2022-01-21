import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_complete_guide/screens/MainPage.dart';
import 'package:flutter_complete_guide/screens/SecondPage.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:flutter_complete_guide/widgets/pickers/MyImagePicker.dart';
import 'package:flutter_complete_guide/screens/test.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          //fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Actions sur Mes Informations',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30, color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          /*
          buildListTile('Picker02', null, () {
            Navigator.of(context).pushNamed(MyImagePicker.routeName);
            / *Navigator.of(context).pushNamed(
              MyImagePicker.routeName,
              arguments: {
                'title': "Titre envoyé",
              },
            );* /
          }),
          buildListTile('AuthExampleApp', null, () {
            Navigator.of(context).pushNamed(AuthExampleApp.routeName);
          }),
          */
          buildListTile('Acceuil', Icons.home, () {
            Navigator.of(context).pushReplacementNamed(MainPage.routeName);
          }),
          buildListTile('the Map', Icons.settings, () {
            Navigator.of(context).pushNamed(SecondPage.routeName);
          }),
          buildListTile('Chat', Icons.message, () {
            Navigator.of(context).pushNamed(ChatScreen.routeName);
          }),
          /*
          buildListTile('Se Connecter', Icons.exit_to_app, () {
            Navigator.of(context).pushNamed(AuthScreen.routeName);
          }), //pushReplacementNamed
          */
          buildListTile('Déconnexion', Icons.logout, () async {
            //Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            await FirebaseAuth.instance.signOut();
          }),
        ],
      ),
    );
  }
}
