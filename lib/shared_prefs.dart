import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  SharedPrefs._();

  static const String _devModeKey = "developer-mode";
  static const bool _devModeDefault = false;

  final List<Function> lateSets = [];

  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool? getDeveloperMode(){
    if(_prefs == null){
      init();
      return null;
    }
    final bool? devMode = _prefs?.getBool(_devModeKey);
    if(devMode == null){
      return _devModeDefault;
    }else{
      return devMode;
    }
  }

  static Future<void> setDeveloperMode(bool isEnabled) async{
    await init();
    await _prefs!.setBool(_devModeKey, isEnabled);
  }
}
