class RegexValidator {
  RegexValidator._();

  // Regex patterns
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp password = RegExp(
    r'^.{6,}$',
  );

  static final RegExp projectName = RegExp(
    r'^.{3,}$',
  );

  static final RegExp projectDescription = RegExp(
    r'^.{5,}$',
  );

  static final RegExp taskTitle = RegExp(
    r'^.{3,}$',
  );

  static final RegExp taskDescription = RegExp(
    r'^.{5,}$',
  );

  // Error messages
  static const String emailError =
      'Please enter a valid email address';

  static const String passwordError =
      'Password must be at least 6 characters';

  static const String projectNameError =
      'Project name must be at least 3 characters';

  static const String projectDescriptionError =
      'Description must be at least 5 characters';

  static const String taskTitleError =
      'Task title must be at least 3 characters';

  static const String taskDescriptionError =
      'Task description must be at least 5 characters';

  // Validators
  static String? validateEmail(String value) {
    final v = value.trim();

    if (v.isEmpty) {
      return 'Email is required';
    }

    return email.hasMatch(v) ? null : emailError;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }

    return password.hasMatch(value)
        ? null
        : passwordError;
  }

  static String? validateProjectName(String value) {
    final v = value.trim();

    if (v.isEmpty) {
      return 'Project name is required';
    }

    return projectName.hasMatch(v)
        ? null
        : projectNameError;
  }

  static String? validateProjectDescription(String value) {
    final v = value.trim();

    if (v.isEmpty) {
      return 'Description is required';
    }

    return projectDescription.hasMatch(v)
        ? null
        : projectDescriptionError;
  }

  static String? validateTaskTitle(String value) {
    final v = value.trim();

    if (v.isEmpty) {
      return 'Task title is required';
    }

    return taskTitle.hasMatch(v)
        ? null
        : taskTitleError;
  }

  static String? validateTaskDescription(String value) {
    final v = value.trim();

    if (v.isEmpty) {
      return 'Task description is required';
    }

    return taskDescription.hasMatch(v)
        ? null
        : taskDescriptionError;
  }
}