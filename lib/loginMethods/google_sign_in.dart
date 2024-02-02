import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Returns true if email address is in use.
Future<bool> checkIfEmailInUse(String emailAddress) async {
  try {
    // Fetch sign-in methods for the email address
    final list =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);
    print(list);
    // In case list is not empty
    if (list.isNotEmpty) {
      // Return true because there is an existing
      // user using the email address
      return true;
    } else {
      // Return false because email adress is not in use
      return false;
    }
  } catch (error) {
    // Handle error
    // ...
    return true;
  }
}

CustomSignInWithGoogle() async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(user.user?.displayName);
  } catch (e) {
    print(e);
  }
}

CustomSignOut() async {
  GoogleSignInAccount? gUser = await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  print(gUser?.displayName);
}
