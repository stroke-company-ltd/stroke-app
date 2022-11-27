
import 'package:flutter/material.dart';
import 'package:stroke/widgets/home_page.dart';

class ChecklistPage extends HomePage{
  ChecklistPage() : super.from(label: "checklist", icon: const Icon(Icons.analytics), widget: _ChecklistPageWidget());
}

class _ChecklistPageWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
    return const Text("TODO");
  }

}
