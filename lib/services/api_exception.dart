import 'package:flutter/material.dart' ;

class ApiException implements Exception {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  String toString() {
    //  return "$_prefix$_message";
    return _prefix ;
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String message])
      : super(message, "Error During Communication with the server.");
}

class BadRequestException extends ApiException {
  BadRequestException([String message]) : super(message, "Invalid Request");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([String message]) : super(message, "Unauthorised exception");
}

class InvalidInputException extends ApiException {
  InvalidInputException([String message]) : super(message, "Invalid Input");
}