import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke/state/checklists.dart';
import 'package:stroke/state/groups.dart';
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
            primaryColor: Colors.black,
            widget: _ChecklistPageWidget());
}

class _ChecklistPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GroupMemberId myself = GroupMemberId();
    GroupCollection groups = GroupCollection(groups: [
      Group(
        metadata: GroupMetadata(name: "group1"),
        checklists: [
          Checklist(metadata: ChecklistMetadata(name: "Bier1")),
          Checklist(metadata: ChecklistMetadata(name: "Bier2")),
          Checklist(metadata: ChecklistMetadata(name: "Bier3"))
        ],
        myself: myself,
      ),
      Group(
        metadata: GroupMetadata(name: "group2"),
        checklists: [
          Checklist(metadata: ChecklistMetadata(name: "Waschmaschine")),
          Checklist(metadata: ChecklistMetadata(name: "Trockner"))
        ],
        myself: myself,
      )
    ]);
    if (groups.groupCount == 0) {
      return const Center(child: Text("you are not part of a group"));
    }

    //TODO exclud groups with no checklist.
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: groups.groupCount,
        itemBuilder: (context, idx) {
          final Group group = groups[idx % groups.groupCount];
          //GroupMember myself = group.members.list.firstWhere((member) => member.id == group.myself);
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: group.metadata),
              ChangeNotifierProvider.value(value: group.checklists),
            ],
            child: _ChecklistGroupWidget(myself: group.myself),
          );
        });
  }
}

class _ChecklistGroupWidget extends StatelessWidget {
  final GroupMemberId _myself;
  const _ChecklistGroupWidget({Key? key, required GroupMemberId myself})
      : _myself = myself,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // final GroupMetadata metadata = context.watch<GroupMetadata>();
    final ChecklistCollection checklists = context.watch<ChecklistCollection>();

    if (checklists.checklistCount == 0) {
      return const Center(child: Text("no checklists"));
    }

    return PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: checklists.checklistCount > 1 ? null : 1,
        itemBuilder: (context, idx) {
          //find the provider that acually identifies the local user.
          final Checklist checklist =
              checklists[idx % checklists.checklistCount];

          return MultiProvider(providers: [
            ChangeNotifierProvider.value(value: checklist.scoreboard[_myself]),
            ChangeNotifierProvider.value(value: checklist.metadata)
          ], child: const _ChecklistWidget());
        });
  }
}

class _ChecklistWidget extends StatelessWidget {
  const _ChecklistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Score score = context.watch<Score>();
    ChecklistMetadata metadata = context.watch<ChecklistMetadata>();
    return GestureDetector(
      onDoubleTap: () => score.score = score.score + 1,
      child: Container(
        color: metadata.color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
        child: Center(
          child: Column(
            children: [Text(metadata.name), Text("${score.score}")],
          ),
        ),
      ),
    );
  }
}
