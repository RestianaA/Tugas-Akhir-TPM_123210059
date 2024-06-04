String caesarCipher(String text, int shift) {
  StringBuffer result = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    if (char.isNotEmpty) {
      int code = char.codeUnitAt(0);

      // Enkripsi hanya untuk huruf alfabet
      if (code >= 65 && code <= 90) {
        char = String.fromCharCode(((code - 65 + shift) % 26) + 65);
      } else if (code >= 97 && code <= 122) {
        char = String.fromCharCode(((code - 97 + shift) % 26) + 97);
      }
    }
    result.write(char);
  }

  return result.toString();
}
