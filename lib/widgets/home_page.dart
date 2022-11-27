import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:stroke/error_handler.dart';
import 'package:stroke/widgets/checklist_page.dart';
import 'package:stroke/widgets/dev_page.dart';
import 'package:stroke/widgets/settings_page.dart';

class HomePageScaffold extends StatelessWidget {
  const HomePageScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomePages(pages: [
                  ChecklistPage(),
                  SettingsPage(),
                ], index: HomePageIndex(index: 0))),
        ChangeNotifierProvider(create: (_) => ErrorHandler.getInstance()),
        ChangeNotifierProvider(
            create: (_) => DeveloperModeSwitch.fromPrefs())
        //root state.
      ],
      child: Builder(builder: (context) {
        //enable developer page?
        DeveloperModeSwitch devMode = context.watch<DeveloperModeSwitch>();
        if (devMode.isEnabled &&
            !context.read<HomePages>().hasPage<DevHomePage>()) {
          SchedulerBinding.instance.addPostFrameCallback((_) =>
              context.read<HomePages>().addHomePage(homePage: DevHomePage()));
        } else if (!devMode.isEnabled &&
            context.read<HomePages>().hasPage<DevHomePage>()) {
          SchedulerBinding.instance.addPostFrameCallback((_) =>
              context.read<HomePages>().removeHomePage<DevHomePage>());
        }

        print(context.read<HomePages>().pages);

        return Scaffold(
          body: Builder(builder: (context) {
            final HomePages homePages = context.watch<HomePages>();
            final List<Widget> children = homePages.pages
                .map((page) => MultiProvider(providers: [
                      ChangeNotifierProvider(create: (_) => page.container),
                      ChangeNotifierProvider(create: (_) => page.metadata)
                    ], child: page.container.createBuilder()))
                .toList();

            return ChangeNotifierProvider(
                create: (_) => homePages.pageIndex, //provides HomePageIndex
                child: Builder(builder: (context) {
                  return IndexedStack(
                      index: context.watch<HomePageIndex>().index,
                      children: children);
                }));
          }),
          bottomNavigationBar: Builder(builder: (context) {
            final HomePages homePages = context.watch<HomePages>();
            context.watch<DeveloperModeSwitch>();
            return ChangeNotifierProvider(
              create: (_) => HomePageMetadataNotifier(
                metadatas:
                    homePages.pages.map((page) => page.metadata).toList(),
              ),
              child: Builder(builder: (context) {
                context.watch<HomePageMetadataNotifier>();
                context.watch<DeveloperModeSwitch>();
                final List<BottomNavigationBarItem> items = homePages.pages
                    .map((page) => BottomNavigationBarItem(
                        icon: page.metadata.icon, label: page.metadata.label))
                    .toList();
                return ChangeNotifierProvider(
                    create: (_) => homePages.pageIndex,
                    child: Builder(builder: (context) {
                      HomePageIndex pageIndex = context.watch<HomePageIndex>();
                      context.watch<DeveloperModeSwitch>();
                      return BottomNavigationBar(
                        type : BottomNavigationBarType.fixed,
                        backgroundColor: Colors.black,
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.grey,
                        items: items,
                        currentIndex: pageIndex.index,
                        onTap: (idx) => pageIndex.index = idx,
                      );
                    }));
              }),
            );
          }),
        );
      }),
    );
  }
}

class HomePageIndex extends ChangeNotifier {
  int _index;
  HomePageIndex({required int index}) : _index = index;

  int get index => _index;
  set index(int value) {
    if (_index == value) return;
    _index = value;
    notifyListeners();
  }
}

class HomePageContainer extends ChangeNotifier {
  Widget _widget;
  Builder? _cachedBuilder;

  HomePageContainer({required Widget widget}) : _widget = widget;
  Widget get widget => _widget;
  set widget(Widget value) {
    if (identical(_widget, value)) return;
    _widget = value;
    notifyListeners();
  }

  Builder createBuilder() {
    return _cachedBuilder ??= Builder(
        builder: (context) => context.watch<HomePageContainer>().widget);
  }
}

class HomePages extends ChangeNotifier {
  final List<HomePage> _pages;
  final HomePageIndex _index;

  HomePages({required List<HomePage> pages, required HomePageIndex index})
      : _pages = pages,
        _index = index;

  addHomePage({required HomePage homePage}) {
    _pages.add(homePage);
    notifyListeners();
  }

  bool hasPage<T extends HomePage>() {
    for (var page in _pages) {
      if (page is T) return true;
    }
    return false;
  }

  List<HomePage> get pages => List.unmodifiable(_pages);
  HomePageIndex get pageIndex => _index;

  bool removeHomePage<T extends HomePage>() {
    for (var page in _pages) {
      if (page is T) {
        _pages.remove(page);
        //fix index.
        if (_index.index >= _pages.length) {
          _index.index = _pages.length - 1;
        }
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}

class HomePageMetadata extends ChangeNotifier {
  Icon _icon;
  String _label;
  HomePageMetadata({required Icon icon, required String label})
      : _label = label,
        _icon = icon;

  Icon get icon => _icon;
  set icon(Icon value) {
    if (identical(_icon, value)) return;
    _icon = value;
    notifyListeners();
  }

  String get label => _label;
  set label(String value) {
    if (_label == value) return;
    _label = value;
    notifyListeners();
  }
}

//simple utility struct.
class HomePage {
  final HomePageMetadata metadata;
  final HomePageContainer container;
  HomePage({required this.metadata, required this.container});

  HomePage.from(
      {required String label, required Icon icon, required Widget widget})
      : metadata = HomePageMetadata(icon: icon, label: label),
        container = HomePageContainer(widget: widget);
}

class HomePageMetadataNotifier extends ChangeNotifier {
  HomePageMetadataNotifier({required List<HomePageMetadata> metadatas}) {
    for (var metadata in metadatas) {
      metadata.addListener(() => notifyListeners());
    }
  }
}
