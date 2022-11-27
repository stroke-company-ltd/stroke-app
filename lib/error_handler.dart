import 'package:flutter/material.dart';

//TODO remove singleton structure and move to widget tree using provider.
class ErrorHandler extends ChangeNotifier{

  static ErrorHandler? _instance;

  static ErrorHandler getInstance() {

    return _instance ??= ErrorHandler._();
  }

  final List<_AbstractError> _errors;
  final List<Function> postops = [];
  bool hasNewError = false;

  ErrorHandler._() : _errors = [];

  void afterBuildFrame(){
    hasNewError = false;
    for (var op in postops){
      op();
    }
    notifyListeners();
  }

  void addPostFrameOperation(Function op){
    postops.add(op);
  }

  void onFlutterError(FlutterErrorDetails details){
    //if(_errors.contains(_FlutterError(details)))return;
    _errors.add(_FlutterError(details));
    hasNewError = true;
  }

  void onPlatformError(Object err, StackTrace stack){
    _errors.add(_PlatformError(err, stack));
    hasNewError = true;
  }

  List<_AbstractError> get errors => List.unmodifiable(_errors);
  bool get hasError => _errors.isNotEmpty;

}

abstract class _AbstractError extends ChangeNotifier{
  int _count = 0;

  int get count => _count;
  void incrementCount() {
    _count++;
    notifyListeners();
  }

}

class _FlutterError extends _AbstractError {
  FlutterErrorDetails errorDetails;
  _FlutterError(this.errorDetails);

  @override
  bool operator==(Object other){
    if(other is! _FlutterError)return false;
    return other.errorDetails.toString() == errorDetails.toString();
  }

  @override
  int get hashCode => errorDetails.stack.hashCode;

}

class _PlatformError extends _AbstractError{
  Object error;
  StackTrace stack;
  _PlatformError(this.error, this.stack);
}


