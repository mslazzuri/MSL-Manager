import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:typed_data';

class EncryptionHelper {
  // Derive a 32-byte AES key from the userId
  static encrypt.Key generateKeyFromUserId(String userId) {
    final bytes = utf8.encode(userId);
    final digest = sha256.convert(bytes); // 32-byte hash
    final key = encrypt.Key(Uint8List.fromList(digest.bytes));
    return key;
  }

  static String encryptWord(String word, String userId) {
    final key = generateKeyFromUserId(userId);
    final iv = encrypt.IV.fromSecureRandom(16); // use a unique random IV

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(word, iv: iv);

    // Save both encrypted text and iv, separated by a delimiter
    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptWord(String encryptedWithIv, String userId) {
    final key = generateKeyFromUserId(userId);

    // Split into IV and encrypted text
    final parts = encryptedWithIv.split(':');
    if (parts.length != 2) throw FormatException('Invalid encrypted format');

    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
