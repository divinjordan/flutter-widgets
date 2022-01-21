import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';

@immutable
class Utilisateur {
  Utilisateur({
    @required this.username,
    @required this.email,
    @required this.image_url,
  });

  Utilisateur.fromJson(Map<String, Object> json)
      : this(
          username: json['username'] as String,
          email: json['email'] as String,
          image_url: json['image_url'] as String,
        );

  final String username;
  final String email;
  final String image_url;

  Map<String, Object> toJson() {
    return {
      'username': username,
      'email': email,
      'image_url': image_url,
    };
  }
}
