import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke/state/dev_mode_switch.dart';
import 'package:stroke/widgets/dev_page.dart';

class DevModeWrapper extends StatefulWidget {
  final Widget child;

  const DevModeWrapper({required this.child, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DevModeWrapperState();
}

class _DevModeWrapperState extends State<DevModeWrapper> {
  late final DeveloperModeMainWidget developerPage;

  int index = 0;

  @override
  void initState() {
    super.initState();
    developerPage = const DeveloperModeMainWidget();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DeveloperModeSwitch.fromPrefs(),
      child: Builder(
        builder: (ctx) {
          if (ctx.watch<DeveloperModeSwitch>().isEnabled) {
            return Scaffold(
              body: IndexedStack(
                index: index,
                children: [widget.child, developerPage],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey,
                onTap: (idx) => setState(()=>index = idx),
                currentIndex: index,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "application"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.build), label: "dev-mode"),
                ],
              ),
            );
          } else {
            return widget.child;
          }
        },
      ),
    );
  }
}
