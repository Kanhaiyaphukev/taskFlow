import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/shared/widgets/regx_validator.dart';

void main() {
  group('RegexValidator Tests', () {
    test('valid email should return null', () {
      final result =
      RegexValidator.validateEmail('test@example.com');

      expect(result, isNull);
    });

    test('invalid email should return error', () {
      final result =
      RegexValidator.validateEmail('invalid-email');

      expect(result, isNotNull);
    });

    test('empty email should return required error', () {
      final result =
      RegexValidator.validateEmail('');

      expect(result, 'Email is required');
    });

    test('valid password should return null', () {
      final result =
      RegexValidator.validatePassword('password123');

      expect(result, isNull);
    });

    test('short password should return error', () {
      final result =
      RegexValidator.validatePassword('123');

      expect(
        result,
        'Password must be at least 6 characters',
      );
    });

    test('valid project name should return null', () {
      final result =
      RegexValidator.validateProjectName('TaskFlow');

      expect(result, isNull);
    });

    test('short project name should return error', () {
      final result =
      RegexValidator.validateProjectName('AB');

      expect(
        result,
        'Project name must be at least 3 characters',
      );
    });

    test('valid project description should return null', () {
      final result =
      RegexValidator.validateProjectDescription(
        'Task management application',
      );

      expect(result, isNull);
    });

    test('short project description should return error', () {
      final result =
      RegexValidator.validateProjectDescription('Test');

      expect(
        result,
        'Description must be at least 5 characters',
      );
    });
  });
}