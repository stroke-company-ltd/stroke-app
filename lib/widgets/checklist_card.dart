import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stroke/state/checklists.dart';
import 'package:stroke/state/groups.dart';
import 'package:stroke/widgets/placeholder_page.dart';

class ChecklistProviderWidget extends StatelessWidget {
  final Checklist _checklist;
  final bool _owned;

  const ChecklistProviderWidget(
      {required Checklist checklist, required bool owned, Key? key})
      : _checklist = checklist,
        _owned = owned,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupMemberId myself = context.watch<GroupMemberId>();
    final Score score = _checklist.scoreboard[myself];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _checklist.metadata),
        ChangeNotifierProvider.value(value: score),
      ],
      child: ChecklistWidget(
        owned: _owned,
      ),
    );
  }
}

class ChecklistWidget extends StatelessWidget {
  final bool _owned;

  const ChecklistWidget({Key? key, required bool owned})
      : _owned = owned,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChecklistMetadata metadata = context.watch<ChecklistMetadata>();
    final Score score = context.watch<Score>();

    List<Widget> titleWidgets = [
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          metadata.name,
          style: GoogleFonts.oswald(fontSize: 48),
          textAlign: TextAlign.center,
        ),
      ),
    ];
    if (_owned) {
      titleWidgets.add(Container(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PlaceholderPage()));
          },
          padding: const EdgeInsets.all(0),
          iconSize: 35,
          icon: const Icon(Icons.settings_outlined),
        ),
      ));
    } else {
      titleWidgets.add(Container(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PlaceholderPage()));
          },
          padding: const EdgeInsets.all(0),
          iconSize: 35,
          icon: const Icon(Icons.info_outline_rounded),
        ),
      ));
    }

    List<Widget> stackChildren = [
      const _CounterWidget(),
      Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: titleWidgets,
                ),
                Text(
                  "description",
                  style: GoogleFonts.oswald(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    ];

    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          ///
          score.score++;
        },
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: metadata.color,
          child: Stack(
            alignment: Alignment.center,
            children: stackChildren,
          ),
        ),
      ),
    );
  }
}

class _CounterWidget extends StatefulWidget {
  const _CounterWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterState();
}

class _CounterState extends State<_CounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    final curvedAnim = CurvedAnimation(
        parent: animController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn);

    animation = Tween<double>(begin: 1.0, end: 1.2).animate(curvedAnim)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animController.reverse();
        }
      });
    //widget.score.addListener(animController.forward);
  }

  @override
  Widget build(BuildContext context) {
    final Score score = context.watch<Score>();
    score.addListener(animController.forward);
    return Transform.scale(
        scale: animation.value,
        child: Text("${score.score}",
            style: GoogleFonts.oswald(
              fontSize: 64 + (min(score.score.toDouble(), 25.0) / 25.0) * 64,
            )));
  }
}
