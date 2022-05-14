class Validator {
  static String? nameValidator(String? name) {
    if (name!.isEmpty) {
      return 'Please enter a valid username';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Password is required';
    } else if (password.length < 8){
      return 'Password must be eight characters or more';
    }
    return null;
  }
}
