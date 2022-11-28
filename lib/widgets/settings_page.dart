import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:stroke/widgets/dev_page.dart';
import 'package:stroke/widgets/home_page.dart';

class SettingsPage extends HomePage {
  SettingsPage()
      : super.from(
            label: "settings",
            iconSelected: const Icon(Icons.settings),
            iconUnselected: const Icon(Icons.settings_outlined),
            widget: const _SettingsPageWidget());
}

class _SettingsPageWidget extends StatelessWidget {

  const _SettingsPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeveloperModeSwitch devMode = context.watch<DeveloperModeSwitch>();

    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text("General"),
          tiles: [
            SettingsTile.switchTile(
                initialValue: devMode.isEnabled,
                onToggle: (enabled) {
                  SchedulerBinding.instance
                      .addPostFrameCallback((_) => devMode.toggle());
                },
                title: const Text("Developer-Mode"))
          ],
        )
      ],
    );
  }
}
