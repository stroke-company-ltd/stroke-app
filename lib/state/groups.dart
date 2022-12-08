import 'package:flutter/material.dart';
import 'package:stroke/state/checklists.dart';

class GroupCollection extends ChangeNotifier {
  final List<Group> _groups;

  GroupCollection({List<Group>? groups}) : _groups = groups ?? [];

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  bool removeGroup(Group group) {
    if (_groups.remove(group)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  List<Group> get groups => List.unmodifiable(_groups);

  Group operator [](int idx) => _groups[idx];

  int get groupCount => _groups.length;
}

class Group {
  final GroupMetadata _metadata;
  final GroupMemberCollection _members;
  final ChecklistCollection _checklists;
  final GroupMemberId _owner;

  Group(
      {required GroupMetadata metadata,
      GroupMemberCollection? members,
      List<Checklist>? checklists,
      required GroupMemberId owner})
      : _metadata = metadata,
        _members = members ?? GroupMemberCollection(),
        _checklists = ChecklistCollection(checklists: checklists), 
        _owner = owner;

  GroupMetadata get metadata => _metadata;
  GroupMemberCollection get members => _members;
  ChecklistCollection get checklists => _checklists;
  GroupMemberId get owner => _owner;
}

class GroupMetadata extends ChangeNotifier {
  String _name;

  GroupMetadata({required String name}) : _name = name;

  String get name => _name;
  set name(String value) {
    if (value == _name) return;
    _name = value;
    notifyListeners();
  }
}

class GroupMemberCollection extends ChangeNotifier {
  final List<GroupMember> _members;

  GroupMemberCollection({List<GroupMember>? members}) : _members = members ?? [];

  void addMember(GroupMember member) {
    _members.add(member);
    notifyListeners();
  }

  bool removeMember(GroupMember member) {
    if (_members.remove(member)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  List<GroupMember> get list => List.unmodifiable(_members);
}

class GroupMember {
  final GroupMemberMetadata _metadata;
  final GroupMemberId _id;
  GroupMember({required GroupMemberMetadata metadata, GroupMemberId? id})
      : _metadata = metadata,
        _id = id ?? GroupMemberId();

  GroupMemberMetadata get metadata => _metadata;
  GroupMemberId get id => _id;

  @override
  bool operator ==(Object other) {
    return id == other;
  }

  @override
  int get hashCode => id.hashCode;
}

class GroupMemberMetadata extends ChangeNotifier {
  String _name;
  GroupMemberMetadata({required String name}) : _name = name;

  String get name => _name = name;
  set name(String value) {
    if (value == _name) return;
    _name = value;
    notifyListeners();
  }
}

class GroupMemberId extends ChangeNotifier{}
