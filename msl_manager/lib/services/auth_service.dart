import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:msl_manager/services/encryption.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createServicesCollectionForUser(String userId) async
  {
    // Create a new collection for the user
    await FirebaseFirestore.instance.collection('services').doc(userId).set({
      'services': [],
    });
  }

  Future<UserCredential> register(
    String firstName,
    String lastName,
    String phone,
    String email,
    String password,
  ) async {
    try{
      
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

        // Create the services collection for the user
        await createServicesCollectionForUser(uid);
      }

      // 4. Return the credentialq
      return userCredential;

    }
    catch (e) {
      // Handle any errors that occur during registration
      throw Exception('Registration failed: $e');
    }    
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Getters

  // User ID getter
  String? get currentUserId {
    User? user = _auth.currentUser;
    return user?.uid;
  }
  
  // Name getter
  Future<String?> get currentUserName async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return '${doc['firstName']} ${doc['lastName']}';
      }
    }
    return null;
  }

  // Email getter
  Future<String?> get currentUserEmail async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc['email'];
      }
    }
    return null;
  }

  // Phone getter
  Future<String?> get currentUserPhone async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc['phone'];
      }
    }
    return null;
  }

  // Get services list
  Future<List<Map<String, dynamic>>> getServicesList(String userId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final services = data?['services'];

      if (services is List) {
        return services.map<Map<String, dynamic>>((item) {
          try {
            return {
              ...item,
              'password': EncryptionHelper.decryptWord(item['password'], userId),
              'email': EncryptionHelper.decryptWord(item['email'], userId),
              'username': EncryptionHelper.decryptWord(item['username'], userId),
              'service': EncryptionHelper.decryptWord(item['service'], userId),
            };
          } catch (e) {
            debugPrint('Error decrypting service: $e');
            return item; // fallback to raw encrypted data or skip this entry
          }
        }).toList();
      }
    }

    return [];
  }

  // Add a service
  Future<void> addServiceToUser({
    required String userId,
    required String serviceName,
    required String email,
    required String username,
    required String password,
  }) async {
    final encryptedService = EncryptionHelper.encryptWord(serviceName, userId);
    final encryptedEmail = EncryptionHelper.encryptWord(email, userId);
    final encryptedusername = EncryptionHelper.encryptWord(username, userId);
    final encryptedPassword = EncryptionHelper.encryptWord(password, userId);

    final serviceData = {
      'service': encryptedService,
      'email': encryptedEmail,
      'username': encryptedusername,
      'password': encryptedPassword,
    };

    final userDocRef = FirebaseFirestore.instance.collection('services').doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDocRef);

      if (!snapshot.exists) {
        // If the user document doesn't exist, create it with the new service
        transaction.set(userDocRef, {
          'services': [serviceData],
        });
      } else {
        // If it exists, append to the existing services array
        final currentServices = List<Map<String, dynamic>>.from(snapshot.get('services') ?? []);
        currentServices.add(serviceData);
        transaction.update(userDocRef, {
          'services': currentServices,
        });
      }
    });
  }

  // Update service
  Future<void> udpateService({
    required int index,
    required String userId,
    required String newService,
    required String newEmail,
    required String newUsername,
    required String newPassword
  }) async {
    
    try{
      
      final docRef = FirebaseFirestore.instance.collection('services').doc(userId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        throw('Document does not exist.');
      }

      List<dynamic> services = snapshot.data()?['services'] ?? [];

      if (index < 0 || index >= services.length) {
        throw('Invalid service index.');
      }

      // Encrypt new data
      final encryptedService = EncryptionHelper.encryptWord(newService, userId);
      final encryptedEmail = EncryptionHelper.encryptWord(newEmail, userId);
      final encryptedUsername = EncryptionHelper.encryptWord(newUsername, userId);
      final encryptedPassword = EncryptionHelper.encryptWord(newPassword, userId);

      // Update the specific service in the list
      services[index] = {
        'service': encryptedService,
        'email': encryptedEmail,
        'username': encryptedUsername,
        'password': encryptedPassword,
      };

      // Write the whole updated array back
      await docRef.update({
        'services': services,
      });

      debugPrint('Service at index $index updated successfully.');

    } catch (e)
    {
      debugPrint("Error updating service: $e");
    }
  }

  Future<void> deleteService({
    required String userId,
    required int index,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('services').doc(userId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        throw('Document does not exist.');
      }

      List<dynamic> services = List.from(snapshot.data()?['services'] ?? []);

      if (index < 0 || index >= services.length) {
        throw('Invalid service index.');
      }

      // REMOVE service at this index
      services.removeAt(index);

      // Write the whole updated array back
      await docRef.update({
        'services': services,
      });

      debugPrint('Service at index $index deleted successfully.');
    } catch (e) {
      debugPrint('Error deleting service: $e');
    }
  }
}