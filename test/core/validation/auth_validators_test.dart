import 'package:evendly_app/core/validation/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators', () {
    test('requires both login fields', () {
      expect(
        AuthValidators.validateLogin(email: ' ', password: 'secret'),
        'Email & password wajib diisi.',
      );
    });

    test('validates required, matching, and secure sign-up fields', () {
      expect(
        AuthValidators.validateSignUp(
          name: 'Fredi',
          email: 'fredi@example.com',
          password: 'short',
          confirmation: 'short',
        ),
        'Password minimal 6 karakter.',
      );
      expect(
        AuthValidators.validateSignUp(
          name: 'Fredi',
          email: 'fredi@example.com',
          password: 'secure1',
          confirmation: 'secure2',
        ),
        'Konfirmasi password tidak sama.',
      );
      expect(
        AuthValidators.validateSignUp(
          name: 'Fredi',
          email: 'fredi@example.com',
          password: 'secure1',
          confirmation: 'secure1',
        ),
        isNull,
      );
    });
  });
}
