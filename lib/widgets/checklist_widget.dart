import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke/state/checklists.dart';
import 'package:stroke/widgets/placeholder_page.dart';

class ChecklistWidget extends StatefulWidget {
  final ChecklistMetadata metadata;
  final Score score;
  final bool owned;

  const ChecklistWidget(
      {Key? key,
      required this.metadata,
      this.owned = false,
      required this.score})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChecklistWidgetState();
}

class ChecklistWidgetState extends State<ChecklistWidget>
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
  }

  void increment() {
    setState(() {
      widget.score.score = widget.score.score + 1;
      animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleWidgets = [
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          widget.metadata.name,
          style: GoogleFonts.oswald(fontSize: 48),
          textAlign: TextAlign.center,
        ),
      ),
    ];
    if (widget.owned) {
      titleWidgets.add(Container(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const PlaceholderPage()));
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const PlaceholderPage()));
          },
          padding: const EdgeInsets.all(0),
          iconSize: 35,
          icon: const Icon(Icons.info_outline_rounded),
        ),
      ));
    }

    List<Widget> stackChildren = [
      Transform.scale(
        scale: animation.value,
        child: Text("${widget.score.score}",
            style: GoogleFonts.oswald(
                fontSize: 64 +
                    (min(widget.score.score.toDouble(), 25.0) / 25.0) * 64)),
      ),
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

    // if (widget.owned) {
    //   stackChildren.add(
    //     Container(
    //         padding: const EdgeInsets.only(top: 50, right: 20),
    //         alignment: Alignment.topRight,
    //         child: IconButton(
    //             onPressed: () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) {
    //                 return const PlaceholderPage();
    //               }));
    //             },
    //             icon: const Icon(Icons.settings_outlined))),
    //   );
    // }

    return Scaffold(
      body: GestureDetector(
        onDoubleTap: increment,
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: widget.metadata.color,
          child: Stack(
            alignment: Alignment.center,
            children: stackChildren,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
