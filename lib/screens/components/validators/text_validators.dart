class TextValidators {
  static String email(String email) {
    if (!RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
        .hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String name(String name) {
    if (name.length == 0) {
      return 'Name should not be empty';
    }
    return null;
  }

  static String password(String password) {
    if (password.length < 8) {
      return 'Password should have minimum eight characters';
    }
    return null;
  }
}
