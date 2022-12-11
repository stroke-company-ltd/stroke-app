import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:stroke/console.dart';
import 'package:stroke/error_handler.dart';
import 'package:tuple/tuple.dart';

class DeveloperModeMainWidget extends StatelessWidget {
  //static final GlobalKey<NavigatorState> _navKey = GlobalKey();
  const DeveloperModeMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _DevModeConsolePage(),
      const _DevModeDatabasePage(),
      const _DevModeNetworkingPage(),
    ];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Console.instance),
        ChangeNotifierProvider.value(value: ErrorHandler.getInstance())
      ],
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        controller: PageController(),
        itemCount: pages.length,
        itemBuilder: (context, idx) {
          return pages[idx % pages.length];
        },
      ),
    );
  }
}

class _DevModeConsolePage extends StatelessWidget {
  final ScrollController controller = ScrollController();
  _DevModeConsolePage({Key? key}) : super(key: key);

  static const double fontSize = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text("Console")),
          backgroundColor: Colors.red),
      body: Builder(
        builder: (context) {
          context.watch<Console>();
          List<Tuple2<int, Widget>> children = [];
          for (var log in Console.getLogs()) {
            children.add(Tuple2(
              log.time,
              Container(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: RichText(
                    text: TextSpan(
                  text: ">\$ : ",
                  style:
                      const TextStyle(color: Colors.yellow, fontSize: fontSize),
                  children: [
                    TextSpan(
                        text: log.log,
                        style: const TextStyle(color: Colors.white)),
                    TextSpan(
                        text: " <at ${log.line}>",
                        style: const TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: log.count == 1 ? "" : "   (${log.count} times)",
                        style: const TextStyle(color: Colors.lightBlue)),
                  ],
                )),
              ),
            ));
          }

          context.watch<ErrorHandler>();

          for (var error in ErrorHandler.getInstance().errors) {
            children.add(Tuple2(
              error.time,
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                child: RichText(
                    text: TextSpan(
                  text: ">\$ : ",
                  style:
                      const TextStyle(color: Colors.yellow, fontSize: fontSize),
                  children: [
                    TextSpan(
                        text: error.summary,
                        style: const TextStyle(color: Colors.red)),
                    TextSpan(
                        text: " <at ${error.lineSummary}>",
                        style: const TextStyle(color: Colors.grey)),
                    TextSpan(
                        text:
                            error.count == 1 ? "" : "   (${error.count} times)",
                        style: const TextStyle(color: Colors.lightBlue)),
                  ],
                )),
              ),
            ));
          }
          children.sort((a, b) => a.item1.compareTo(b.item1));

          //Console.addLogCallback(() {});

          if (controller.hasClients &&
              controller.position.pixels ==
                  controller.position.maxScrollExtent) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              controller.animateTo(controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn);
            });
          }

          return Container(
            child: ListView(
                padding: const EdgeInsets.only(top: 3),
                physics: const AlwaysScrollableScrollPhysics(),
                children: children.map((e) => e.item2).toList(),
                controller: controller,
                scrollDirection: Axis.vertical),
            color: const Color(0xFF28282e),
          );
        },
      ),
    );
  }
}

class _DevModeDatabasePage extends StatelessWidget {
  const _DevModeDatabasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text("Local Data")),
            backgroundColor: Colors.red),
        body: Builder(builder: (context) {
          throw UnimplementedError();
        }));
  }
}

class _DevModeNetworkingPage extends StatelessWidget {
  const _DevModeNetworkingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text("Networking")),
            backgroundColor: Colors.red),
        body: Builder(builder: (context) {
          throw UnimplementedError();
        }));
  }
}
