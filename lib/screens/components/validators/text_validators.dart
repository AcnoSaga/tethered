class TextValidators {
  static String email(String email) {
    if (!RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
        .hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String name(String name) {
    if (name.isEmpty) {
      return 'Please enter a name';
    }
    if (name.length > 40) {
      return 'Name can not be more than 40 characters';
    }
    return null;
  }

  static String username(String username) {
    if (username.isEmpty) {
      return 'Please enter a username';
    }
    if (username.length > 40) {
      return 'Username can not be more than 40 characters';
    }
    return null;
  }

  static String password(String password) {
    if (password.length < 8) {
      return 'Password should have minimum 8 characters';
    }
    if (password.length > 100) {
      return 'Password should have maximum 100 characters';
    }

    return null;
  }

  static String title(String title) {
    if (title.isEmpty) {
      return 'Please enter a title';
    }
    if (title.length > 40) {
      return 'Title can not be more than 40 characters';
    }
    return null;
  }

  static String description(String description) {
    if (description.isEmpty) {
      return 'Please enter a description';
    }
    if (description.length > 300) {
      return 'Description can not be more than 300 characters';
    }
    return null;
  }

  static String comment(String comment) {
    if (comment.isEmpty) {
      return 'Please enter a comment';
    }
    if (comment.length > 1000) {
      return 'Comment can not be more than 1000 characters';
    }
    return null;
  }
}
