import 'dart:convert';
// import 'dart:html';

import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

void signInWithFacebook(context) async {
  try {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: (['email', 'public_profile']));
    final token = result.accessToken!.token;
    print('Facebook token userID : ${result.accessToken!.grantedPermissions}');
    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/'
        'v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));

    final profile = jsonDecode(graphResponse.body);
    print("Profile is equal to $profile");
    try {
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(facebookCredential);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) =>  Dashboard()),
      // );
    } catch (e) {
      final snackBar = SnackBar(
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        backgroundColor: (Colors.redAccent),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    print("error occurred");
    print(e.toString());
  }
}
