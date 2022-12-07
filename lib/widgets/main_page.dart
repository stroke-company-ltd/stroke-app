import 'package:flutter/material.dart';
import 'package:stroke/state/checklists.dart';
import 'package:stroke/widgets/checklist_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChecklistWidget(
      metadata: ChecklistMetadata(name: "Waschmaschine"),
      owned: true,
      score: Score(score: 0),

    );
  }
}
