import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stroke/state/dev_mode_switch.dart';
import 'package:stroke/state/groups.dart';
import 'package:stroke/widgets/group_page_view.dart';
import 'package:stroke/widgets/placeholder_page.dart';

class GroupsPageViewProviderWidget extends StatelessWidget {
  final GroupCollection _groups;

  const GroupsPageViewProviderWidget(
      {Key? key, required GroupCollection groups})
      : _groups = groups,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _groups)],
      child: GroupsPageViewWidget(),
    );
  }
}

class GroupsPageViewWidget extends StatelessWidget {
  final PageController _controller = PageController();
  GroupsPageViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (Group group in context.watch<GroupCollection>().groups) {
      children.add(GroupPageViewProviderWidget(group: group));
    }
    children.add(const NewGroupCard());
    return PageView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      children: children,
    );
  }
}

class NewGroupCard extends StatelessWidget {
  const NewGroupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int devModeCounter = 0;
    DeveloperModeSwitch devSwitch = context.read<DeveloperModeSwitch>();
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
                  child: Text("New Group",
                      style: GoogleFonts.oswald(fontSize: 48)),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.0,
              child: IconButton(
                onPressed: () {
                  devModeCounter++;
                  if (devModeCounter > 10) {
                    devSwitch.toggle();
                    devModeCounter=0;
                  }
                },
                padding: EdgeInsets.zero,
                iconSize: 100,
                icon: const Icon(Icons.build),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
