import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stroke/state/groups.dart';

class ChecklistCollection extends ChangeNotifier {
  final List<Checklist> _checklists;

  ChecklistCollection({List<Checklist>? checklists})
      : _checklists = checklists ?? [];

  void addChecklist(Checklist checklist) {
    _checklists.add(checklist);
    notifyListeners();
  }

  void removeChecklist(Checklist checklist) {
    _checklists.remove(checklist);
    notifyListeners();
  }

  List<Checklist> get list => List.unmodifiable(_checklists);

  Checklist operator[](int idx) => _checklists[idx];

  int get checklistCount => _checklists.length;
}

class Checklist {
  final ChecklistMetadata _metadata;
  final Scoreboard _scoreboard;

  Checklist({required ChecklistMetadata metadata, Scoreboard? scoreboard})
      : _metadata = metadata,
        _scoreboard = scoreboard ?? Scoreboard();

  ChecklistMetadata get metadata => _metadata;
  Scoreboard get scoreboard => _scoreboard;
}

class ChecklistMetadata extends ChangeNotifier {
  String _name;
  Color _color;
  ChecklistMetadata({required String name, Color? color})
      : _name = name,
        _color = color ??
            Colors.primaries[Random().nextInt(Colors.primaries.length)];

  String get name => _name;

  set name(String value) {
    if (value == _name) return;
    _name = value;
    notifyListeners();
  }
  Color get color => _color;
  set color(Color value){
    if(_color == value)return;
    _color = value;
    notifyListeners();
  }
}

class Scoreboard {
  final Map<GroupMemberId, Score> _scores = {};

  Score operator [](GroupMemberId member) => _scores[member] ?? Score();
}

class Score extends ChangeNotifier {
  int _score;

  Score({int score = 0}) : _score = score;

  int get score => _score;
  set score(int value) {
    if (value == _score) return;
    _score = value;
    notifyListeners();
  }
}
