import 'package:flutter/cupertino.dart';

sealed class FireStoreResult<T> {
  const FireStoreResult();
}

class SUCCESS<T> extends FireStoreResult<T> {
  final T data;

  SUCCESS({required this.data});
}

class FAILURE<T> extends FireStoreResult<T> {
  final Exception exception;

  FAILURE({required this.exception});
}
