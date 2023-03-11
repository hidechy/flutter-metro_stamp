// ignore_for_file: must_be_immutable, cascade_invocations, use_decorated_box

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:station_stamp/screens/not_get_map_screen.dart';

import '../viewmodel/station_stamp_notifier.dart';
import 'stamp_screen.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  List<TabInfo> tabBodyList = [];

  late WidgetRef _ref;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    makeScreenTab();

    return DefaultTabController(
      length: tabBodyList.length,
      child: Scaffold(
        //
        appBar: AppBar(
          title: const Text('Station Stamp'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.blueAccent,
            tabs: tabBodyList.map((TabInfo tab) {
              return Tab(text: tab.label);
            }).toList(),
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotGetMapScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        children: const [
                          Icon(Icons.map),
                          Text('Not Get'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          flexibleSpace: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_train.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),

        //

        body: TabBarView(
          children: tabBodyList.map((tab) => tab.widget).toList(),
        ),

        //
      ),
    );
  }

  ///
  void makeScreenTab() {
    tabBodyList = [];

    final stationStampState = _ref.watch(stationStampProvider);

    final keepTrain = <String>[];

    stationStampState.forEach((element) {
      if (!keepTrain.contains(element.trainName)) {
        tabBodyList.add(
          TabInfo(
            element.trainName,
            StampScreen(trainName: element.trainName),
          ),
        );
      }

      keepTrain.add(element.trainName);
    });
  }
}
