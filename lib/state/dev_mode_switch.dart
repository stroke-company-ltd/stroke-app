
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke/shared_prefs.dart';

class DeveloperModeSwitch extends ChangeNotifier {
  static const String _prefKey = "developer-mode";
  static SharedPreferences? _prefs;

  bool _enabled;

  DeveloperModeSwitch({required bool enabled}) : _enabled = enabled;

  factory DeveloperModeSwitch.fromPrefs() {
    if (_prefs == null) {
      var tmp = DeveloperModeSwitch(enabled: false);
      //schedule pref init.
      () async {
        _prefs = await SharedPreferences.getInstance();
        bool? devMode = _prefs!.getBool(_prefKey);
        if (devMode != null) {
          if (tmp.isEnabled && !devMode) await tmp.disable();
          if (!tmp.isEnabled && devMode) await tmp.enable();
        }
      }();
      return tmp;
    } else {
      bool? devMode = _prefs!.getBool(_prefKey);
      devMode ??= false;
      return DeveloperModeSwitch(enabled: devMode);
    }
  }

  bool get isEnabled => _enabled;

  Future<void> enable() async {
    if (_enabled == true) return;
    _enabled = true;
    await _savePersistant();
    notifyListeners();
  }

  Future<void> disable() async {
    if (_enabled == false) return;
    _enabled = false;
    await _savePersistant();
    notifyListeners();
  }

  Future<void> toggle() async {
    _enabled = !_enabled;
    await _savePersistant();
    notifyListeners();
  }

  Future<void> _savePersistant() async {
    await SharedPrefs.setDeveloperMode(_enabled);
  }
}
