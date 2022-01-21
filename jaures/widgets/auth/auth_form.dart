import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );
  //final _isLogin = true;
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
/* la photo de profil est facultative
    if (_userImageFile == null && !isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Prendre un photo de profil.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
*/
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!isLogin) UserImagePicker(_pickedImage),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Le nom d"utilisateur doit contenir plus de 4 caractères';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Nom Utilisateur*'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'L"adresse email entrée n"est pas valide.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Address Email*',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Le mot de passe doit avoir au moins 7 caractères de long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Mot de Passe*'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('phone'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 9) {
                          return 'Le Numéro de téléphone doit avoir au moins 9 caractères.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Numéro de téléphone*'),
                      onSaved: (value) {
                        //_userPassword = value;
                      },
                    ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('adresse'),
                      validator: (value) {
                        //Facultatif
                        return null;
                      },
                      //keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Adresse du Domicile'),
                      onSaved: (value) {
                        //_userPassword = value;
                      },
                    ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(isLogin ? 'Se Connecter' : 'Valider Creation'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(isLogin ? 'Creation Nouveau Compte' : 'Je possède déja un Compte'),
                      onPressed: () {
                        setState(() {
                          //widget._isLogin = !isLogin;
                          //isLogin = widget._isLogin; //!isLogin;
                          isLogin = !isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
