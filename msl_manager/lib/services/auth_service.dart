import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> register(
    String firstName,
    String lastName,
    String phone,
    String email,
    String password,
  ) async {
    // 1. Await the user creation
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Get the user ID
    final String? uid = userCredential.user?.uid;

    // 3. Check if UID is valid before writing to Firestore
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
      });
    }

    // 4. Return the credential
    return userCredential;
  }


  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}