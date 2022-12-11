import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stroke/state/checklists.dart';
import 'package:stroke/state/groups.dart';
import 'package:stroke/widgets/dev_mode_wrapper.dart';
import 'package:stroke/widgets/groups_page_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GroupMemberId id = GroupMemberId();

    return DevModeWrapper(
      child: ChangeNotifierProvider.value(
        value: id,
        child: GroupsPageViewProviderWidget(
          groups: GroupCollection(
            groups: [
              Group(
                metadata: GroupMetadata(name: "Waschliste"),
                checklists: [
                  Checklist(
                    metadata: ChecklistMetadata(name: "Waschmaschine"),
                  ),
                  Checklist(
                    metadata: ChecklistMetadata(name: "Trockner"),
                  ),
                ],
                members: GroupMemberCollection(
                  members: [
                    GroupMember(
                      metadata: GroupMemberMetadata(name: "karl"),
                    ),
                  ],
                ),
                owner: id,
              ),
              Group(
                metadata: GroupMetadata(name: "Bierliste"),
                checklists: [
                  Checklist(
                    metadata: ChecklistMetadata(name: "Hell"),
                  ),
                  Checklist(
                    metadata: ChecklistMetadata(name: "Export"),
                  ),
                  Checklist(
                    metadata: ChecklistMetadata(name: "Pils"),
                  ),
                  Checklist(
                    metadata: ChecklistMetadata(name: "Kristal"),
                  ),
                ],
                members: GroupMemberCollection(
                  members: [
                    GroupMember(
                      metadata: GroupMemberMetadata(name: "karl"),
                    ),
                  ],
                ),
                owner: id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
