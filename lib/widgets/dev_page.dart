import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke/error_handler.dart';
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
  //static final GlobalKey<NavigatorState> _navKey = GlobalKey();
  const _DevHomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      //key: _navKey,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case "/dev/errors":
            page = _DevModeErrorPage();
            break;
          default:
            page = const _DevModeMainPage();
        }
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => page,
            transitionDuration: const Duration(seconds: 0));
      },
    );
  }
}

class _DevModeMainPage extends StatelessWidget {
  const _DevModeMainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DeveloperMode")),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile.navigation(
                title: const Text("Errors"),
                trailing: Builder(builder: (context) {
                  ErrorHandler errorHandler = context.watch<ErrorHandler>();
                  return Container(
                    child: Text("${errorHandler.errorCount}"),
                    padding: const EdgeInsets.all(10),
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Colors.grey),
                  );
                }),
                onPressed: ((context) {
                  Navigator.pushNamed(context, "/dev/errors");
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _DevModeErrorPage extends StatelessWidget {
  final ScrollController controller = ScrollController();
  _DevModeErrorPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Errors")),
        body: Builder(builder: (context) {
          ErrorHandler errorHandler = context.watch<ErrorHandler>();
          List<Widget> children = [];
          for (var error in errorHandler.errors) {
            children.add(
              ChangeNotifierProvider(
                create: (_) => error,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                          //padding: const EdgeInsets.all(10),
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const ShapeDecoration(
                            color: Colors.grey,
                            shape: CircleBorder(),
                          ),
                          child: Builder(builder: (context) {
                            return Center(
                                child: Text(
                                    "${error.count}"));
                          })),
                      Flexible(
                          child: Column(
                        children: [
                          Text(
                            error.summary,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                          ),
                          Text(
                            error.lineSummary,
                            textAlign: TextAlign.left,
                            textScaleFactor: 0.7,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ))
                    ],
                  ),
                ),
              ),
            );
          }
          return ListView(
              padding: const EdgeInsets.only(top: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              children: children,
              controller: controller,
              scrollDirection: Axis.vertical);
        }));
  }
}
