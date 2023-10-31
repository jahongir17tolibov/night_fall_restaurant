import 'package:flutter/cupertino.dart';

sealed class Result<T> {
  const Result();
}

class SUCCESS<T> extends Result<T> {
  final T data;

  SUCCESS({required this.data});
}

class FAILURE<T> extends Result<T> {
  final Exception exception;

  FAILURE({required this.exception});
}
