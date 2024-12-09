class ApiHost {
  static const address =
      String.fromEnvironment("API_HOST", defaultValue: "localhost");
  static const port = String.fromEnvironment("API_PORT", defaultValue: "5148");
}

class AppConstants {
  static const String loginLabel = 'Login';
  static const String usernameLabel = 'Username (Parts Shop Name)';
  static const String passwordLabel = 'Password';
  static const String newPasswordLabel = 'New Password';
  static const String loginButtonLabel = 'Login';
  static const String registerLabel = 'Register';
  static const String nameLabel = 'Name';
  static const String surnameLabel = 'Surname';
  static const String emailLabel = 'Email';
  static const String phoneLabel = 'Phone';
  static const String genderLabel = 'Gender';
  static const String addressLabel = 'Address';
  static const String postalCodeLabel = 'Postal Code';
  static const String cityLabel = 'City';
  static const String passwordConfirmLabel = 'Confirm Password';
  static const String usernameError = 'Please enter your username';
  static const String newUsernameError = 'Please enter your new username';
  static const String passwordError = 'Please enter your password';
  static const String newPasswordError = 'Please enter your new password';
  static const String nameError = 'Please enter your name';
  static const String surnameError = 'Please enter your surname';
  static const String emailError = 'Please enter a valid email address';
  static const String phoneError = 'Please enter your phone number';
  static const String genderError = 'Please specify your gender';
  static const String newGenderError = 'Please specify new gender';
  static const String addressError = 'Please enter your address';
  static const String postalCodeError = 'Please enter your postal code';
  static const String cityError = 'Please enter your city';
  static const String passwordConfirmError = 'Passwords do not match';
  static const String genericError = 'Please specify a new value';
  static const String registerButtonLabel = 'Register';
}

class AppPadding {
  static const double defaultPadding = 16.0;
}

class AppRadius {
  static const double defaultRadius = 16.0;
  static const double textFieldRadius = 12.0;
  static const double buttonRadius = 12.0;
}
