import 'package:flutter/material.dart';
import 'package:stroke/widgets/home_page.dart';

class ChecklistPage extends HomePage {
  ChecklistPage()
      : super.from(
            label: "checklist",
            iconSelected: const Icon(Icons.amp_stories),
            iconUnselected: const Icon(Icons.amp_stories_outlined),
            // iconSelected: const Icon(Icons.ballot),
            // iconUnselected: const Icon(Icons.ballot_outlined),
            // iconSelected: const Icon(Icons.check_box),
            // iconUnselected: const Icon(Icons.check_box_outlined),
            // iconSelected: const Icon(Icons.circle),
            // iconUnselected: const Icon(Icons.circle_outlined),
            widget: _ChecklistPageWidget());
}

class _ChecklistPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
    //return Text("HI");
  }
}
