import 'package:dio/dio.dart';

class AppError extends DioException {
  Object error;

  AppError(this.error) : super(requestOptions: RequestOptions());
}

class BiometricError extends AppError {
  BiometricError(super.error);
}

class PasswordError extends AppError {
  PasswordError(super.error);
}

class PasscodeError extends AppError {
  PasscodeError(super.error);
}
