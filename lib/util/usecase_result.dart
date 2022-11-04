import 'package:flutter/foundation.dart';

class Result<T> with _ResultMethods<T> {
  late T _data;
  late String _error;
  bool get isError => _error.isNotEmpty;
  String get errorMessage => _error;

  Result._();

  Result._success({required T data}) {
    _data = data;
    _error = '';
  }

  Result._error({required String error}) {
    _error = error;
  }

  static Result<T> success<T>({required T data}) =>
      ResultSuccess<T>(data: data);

  static Result<void> ok() => ResultOk();

  static Result<T> error<T>({String message = "Unknown error"}) =>
      ResultError<T>(error: message);
}

class ResultSuccess<T> extends Result<T> {
  ResultSuccess({required T data}) : super._success(data: data);

  T get data => _data;

  @override
  void when(
      {required Function(T data) onSuccess,
      required Function(String error) onError}) {
    onSuccess(_data);
  }
}

class ResultOk extends Result<void> {
  ResultOk() : super._();

  @override
  void when(
      {required Function onSuccess, required Function(String error) onError}) {
    onSuccess(() {});
  }
}

class ResultError<T> extends Result<T> {
  ResultError({required String error}) : super._error(error: error);

  String get error => _error;

  @override
  void when(
      {required Function(T data) onSuccess,
      required Function(String error) onError}) {
    onError(_error);
  }
}

mixin _ResultMethods<T> {
  void when(
      {required Function(T data) onSuccess,
      required Function(String error) onError}) {}
}
