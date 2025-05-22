class PasswordGenerator {

  String generatePassword({
    required int length,
    bool includeSpecialChars = true,
    bool includeNumbers = true,
  }) {
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = lowercase + uppercase;
    if (includeNumbers) chars += numbers;
    if (includeSpecialChars) chars += specialChars;

    chars = (chars.split('')..shuffle()).join();

    return List.generate(length, (index) => chars[(chars.length * index ~/ length) % chars.length]).join();
  }



}