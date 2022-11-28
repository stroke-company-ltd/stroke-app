
import 'package:flutter/material.dart';

class Console extends ChangeNotifier{
  static const bool enablePrintLog = true;
  static Console? _instance;
  static Console get instance{
    return _instance ??= Console._();
  }

  final List<ConsoleLog> _logs = [];
  int _logSize = 0;

  Console._();

  static void log(String str){
    instance._logSize++;
    // ignore: avoid_print
    if(enablePrintLog)print("$str\n");
    ConsoleLog newLog = ConsoleLog._(str, StackTrace.current);
    for(var log in instance._logs){
      if(log == newLog){
        log.count++;
        instance.notifyListeners();
        return;
      }
    }
    instance._logs.add(newLog);
    instance.notifyListeners();
  }

  static List<ConsoleLog> getLogs(){
    return instance._logs;
  }

  static int logSize(){
    return instance._logSize;
  }

  static void clear(){
    if(instance._logs.isEmpty)return;
    instance._logs.clear();
    instance.notifyListeners();
  }


}

class ConsoleLog{
  final String line;
  final String log;
  int count = 1;

  ConsoleLog._(this.log, StackTrace stack) : line = parseStack(stack);

  static String parseStack(StackTrace stack){
    String rep = stack.toString();
    List<String> lines = rep.split('\n');
    for (var line in lines) {
      if (line.startsWith("#1")) {
        int start = line.indexOf("(") + 1;
        int end = line.indexOf(")");
        return line.substring(start, end);
      }
    }
    return stack.toString();
  }

  @override 
  bool operator==(Object other){
    if(other is! ConsoleLog)return false;
    return other.log == log && other.line == line;
  }

  @override
  int get hashCode => Object.hash(log, line);
}
