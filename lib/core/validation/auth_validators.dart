class AuthValidators {
  const AuthValidators._();

  static String? validateLogin({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Email & password wajib diisi.';
    }
    return null;
  }

  static String? validateSignUp({
    required String name,
    required String email,
    required String password,
    required String confirmation,
  }) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        confirmation.isEmpty) {
      return 'Semua field wajib diisi.';
    }
    if (password != confirmation) {
      return 'Konfirmasi password tidak sama.';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter.';
    }
    return null;
  }
}
