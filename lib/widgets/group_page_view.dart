import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stroke/state/checklists.dart';
import 'package:stroke/state/groups.dart';
import 'package:stroke/widgets/checklist_card.dart';
import 'package:stroke/widgets/placeholder_page.dart';

class GroupPageViewProviderWidget extends StatelessWidget {
  final Group _group;

  const GroupPageViewProviderWidget({required Group group, Key? key})
      : _group = group,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupMemberId myself = context.watch<GroupMemberId>();
    return MultiProvider(providers: [
    ChangeNotifierProvider.value(value: _group.checklists),
    ChangeNotifierProvider.value(value: _group.metadata),

    ], child: GroupPageViewWidget(_group.owner == myself));
  }
}

class GroupPageViewWidget extends StatelessWidget {
  final bool owned;
  final PageController _controller = PageController();

  GroupPageViewWidget(this.owned, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final ChecklistCollection checklists = context.watch<ChecklistCollection>();
    for (Checklist checklist in checklists.list) {
      children.add(
        ChecklistProviderWidget(checklist: checklist, owned: owned),
      );
    }
    children.add(const NewChecklistCard());
    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: children,
      ),
    );
  }
}

class NewChecklistCard extends StatelessWidget {
  const NewChecklistCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupMetadata metadata = context.watch<GroupMetadata>();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const PlaceholderPage(),
                    ),
                  );
                },
                iconSize: 100,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Center(
                  child: Text("New Checklist",
                      style: GoogleFonts.oswald(fontSize: 48)),
                ),
                Center(
                  child: Text(metadata.name,
                      style: GoogleFonts.oswald(fontSize: 16)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
