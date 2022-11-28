import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ErrorHandler extends ChangeNotifier {
  static ErrorHandler? _instance;

  static ErrorHandler getInstance() {
    return _instance ??= ErrorHandler._();
  }

  int _errorCount = 0;
  int get errorCount => _errorCount;
  final List<AbstractError> _errors;
  final List<Function> postops = [];
  bool hasNewError = false;
  bool _callbackInstalled = false;

  ErrorHandler._() : _errors = [];

  void afterBuildFrame() {
    hasNewError = false;
    for (var op in postops) {
      op();
    }
    _callbackInstalled = false;
    notifyListeners();
  }

  void addPostFrameOperation(Function op) {
    postops.add(op);
  }

  void onFlutterError(FlutterErrorDetails details) {
    _errorCount++;
    //if(_errors.contains(_FlutterError(details)))return;
    var newError = _FlutterError(details);
    for (var error in _errors) {
      if (newError == error) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          error.incrementCount();
          notifyListeners();
        });
        return;
      }
    }
    _errors.add(newError);
    hasNewError = true;
    if (!_callbackInstalled) {
      SchedulerBinding.instance.addPostFrameCallback((_) => afterBuildFrame());
    }
  }

  void onPlatformError(Object err, StackTrace stack) {
    _errorCount++;
    var newError = _PlatformError(err, stack);
    for (var error in _errors) {
      if (newError == error) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          error.incrementCount();
          notifyListeners();
        });
        return;
      }
    }
    _errors.add(newError);
    hasNewError = true;
    if (!_callbackInstalled) {
      SchedulerBinding.instance.addPostFrameCallback((_) => afterBuildFrame());
    }
  }

  List<AbstractError> get errors => List.unmodifiable(_errors);
  bool get hasError => _errors.isNotEmpty;
}

abstract class AbstractError extends ChangeNotifier {
  int _count = 1;

  int get count => _count;
  void incrementCount() {
    _count++;
    notifyListeners();
  }

  String get summary;
  String get lineSummary;
}

class _FlutterError extends AbstractError {
  //final FlutterErrorDetails errorDetails;
  @override
  final String lineSummary;
  @override
  final int hashCode;
  @override
  final String summary;
  final String _toString;

  _FlutterError(FlutterErrorDetails errorDetails)
      : lineSummary = _parseStackTrace(errorDetails.stack),
        _toString = errorDetails.toString(),
        hashCode = errorDetails.hashCode,
        summary = "Flutter Error : ${errorDetails.summary.toString()}";

  static String _parseStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return "could not parse line number";
    String rep = stackTrace.toString();
    List<String> lines = rep.split('\n');
    for (var line in lines) {
      if (line.startsWith("#0")) {
        int start = line.indexOf("(") + 1;
        int end = line.indexOf(")");
        return line.substring(start, end);
      }
    }

    return "";
  }

  @override
  bool operator ==(Object other) {
    if (other is! _FlutterError) return false;
    return other.lineSummary == lineSummary;
  }

  @override
  String toString() => _toString;
}

class _PlatformError extends AbstractError {
  final Object error;
  final StackTrace stack;
  @override
  final String lineSummary;
  _PlatformError(this.error, this.stack)
      : lineSummary = parseLineSummary(stack);

  static String parseLineSummary(StackTrace? stackTrace) {
    if (stackTrace == null) return "line number could not be parsed";
    return "line number parsing for PlatformErrors is not implemented yet";
  }

  @override
  String toString() {
    return "Platform Error : \nThe following ${error.toString()} was thrown\n while: \n ${stack.toString()}";
  }

  @override
  operator ==(Object other) {
    if (other is! _PlatformError) return false;
    return error.toString() == other.error.toString() &&
        stack.toString() == other.error.toString();
  }

  @override
  int get hashCode => Object.hash(error.toString(), stack.toString());

  @override
  String get summary => "Platform Error : ${error.toString()}";
}
