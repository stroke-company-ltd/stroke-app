

import 'package:flutter/material.dart';
import 'package:stroke/shared_prefs.dart';
import 'package:stroke/widgets/home_page.dart';

class DeveloperModeSwitch extends ChangeNotifier{
  bool _enabled;
  DeveloperModeSwitch({required bool enabled}) : _enabled = enabled;

  factory DeveloperModeSwitch.fromPrefs(){
    return DeveloperModeSwitch(enabled : SharedPrefs.getDeveloperMode());
  }

  bool get isEnabled => _enabled;
  Future<void> enable() async{
    if(_enabled == true)return;
    _enabled = true;
    await _savePersistant();
    notifyListeners();
  }

  Future<void> disable() async{
    if(_enabled == false)return;
    _enabled = false;
    await _savePersistant();
    notifyListeners();
  }

  Future<void> toggle() async{
    _enabled = !_enabled;
    await _savePersistant();
    notifyListeners();
  }

  Future<void> _savePersistant() async{
    await SharedPrefs.setDeveloperMode(_enabled);
  }

  
}

class DevHomePage extends HomePage{
  DevHomePage() : super.from(label: "development", icon: const Icon(Icons.build), widget: const _DevHomePageWidget());
}

class _DevHomePageWidget extends StatelessWidget{
  const _DevHomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("TODO");
  }

}
