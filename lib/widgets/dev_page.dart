import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke/shared_prefs.dart';
import 'package:stroke/widgets/home_page.dart';

class DeveloperModeSwitch extends ChangeNotifier {
  static const String _prefKey = "developer-mode";
  static SharedPreferences? _prefs;

  bool _enabled;
  final bool _usePrefs;

  DeveloperModeSwitch({required bool enabled, bool usePrefs = false})
      : _enabled = enabled,
        _usePrefs = usePrefs;

  factory DeveloperModeSwitch.fromPrefs() {
    if (_prefs == null) {
      var tmp = DeveloperModeSwitch(enabled: false, usePrefs: true);
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
      return DeveloperModeSwitch(enabled: devMode, usePrefs: true);
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

class DevHomePage extends HomePage {
  DevHomePage()
      : super.from(
            label: "development",
            icon: const Icon(Icons.build),
            widget: const _DevHomePageWidget());
}

class _DevHomePageWidget extends StatelessWidget {
  const _DevHomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("TODO");
  }
}
