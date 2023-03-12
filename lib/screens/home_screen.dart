// ignore_for_file: must_be_immutable, cascade_invocations, non_constant_identifier_names, use_decorated_box

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../extensions/extensions.dart';
import '../model/station_stamp.dart';
import '../utility/utility.dart';
import '../viewmodel/station_stamp_notifier.dart';
import 'not_get_map_screen.dart';
import 'station_info_alert.dart';
import 'station_info_dialog.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final Utility _utility = Utility();

  List<String> trainName = [];

  Map<String, List<StationStamp>> stationStampMap = {};
  Map<String, List<StationStamp>> getStationStampMap = {};

  late BuildContext _context;
  late WidgetRef _ref;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _context = context;
    _ref = ref;

    makeStationStampData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Stamp'),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(child: displayStationStampList()),
                Divider(
                  color: Colors.grey.withOpacity(0.4),
                  thickness: 5,
                ),
                SizedBox(
                  width: context.screenSize.width,
                  height: 120,
                  child: displayStationInfo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  void makeStationStampData() {
    trainName = [];

    stationStampMap = {};
    getStationStampMap = {};

    final stationStampState = _ref.watch(stationStampProvider);

    var list = <StationStamp>[];
    var list2 = <StationStamp>[];

    final keepTrain = <String>[];
    var keepTrainName = '';

    stationStampState.forEach((element) {
      if (keepTrainName != element.trainName) {
        list = [];
        list2 = [];
      }

      if (element.stampGetDate != '') {
        list2.add(element);
      }

      list.add(element);

      stationStampMap[element.trainName] = list;

      getStationStampMap[element.trainName] = list2;

      if (!keepTrain.contains(element.trainName)) {
        trainName.add(element.trainName);
      }

      keepTrainName = element.trainName;

      keepTrain.add(element.trainName);
    });
  }

  ///
  Widget displayStationStampList() {
    final list = <Widget>[];

    trainName.forEach((element) {
      final list2 = <Widget>[];
      stationStampMap[element]?.forEach((element2) {
        list2.add(StationStampBlock(data: element2));
      });

      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(element),
                DefaultTextStyle(
                  style: TextStyle(
                    color: (getStationStampMap[element]!.length ==
                            stationStampMap[element]!.length)
                        ? Colors.yellowAccent
                        : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Text(getStationStampMap[element]!.length.toString()),
                      const Text(' / '),
                      Text(stationStampMap[element]!.length.toString()),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: list2),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  ///
  Widget StationStampBlock({required StationStamp data}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _ref.watch(stationProvider.notifier).getStation(data: data);
          },
          child: CircleAvatar(
            backgroundColor: (data.stampGetDate == '')
                ? Colors.black.withOpacity(0.3)
                : _utility.getTrainColor(trainName: data.trainName),
            radius: 30,
            child: CircleAvatar(
              radius: 28,
              child: Text(data.imageCode),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  ///
  Widget displayStationInfo() {
    final stationState = _ref.watch(stationProvider);

    var getDate = '';
    if (stationState.stampGetDate != '') {
      final exGetDate = stationState.stampGetDate.split('/');
      final getD = DateTime(
        exGetDate[0].toInt(),
        exGetDate[1].toInt(),
        exGetDate[2].toInt(),
      ).yyyymmdd;
      getDate = '$getD取得';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  color: _utility.getTrainColor(
                    trainName: stationState.trainName,
                  ),
                ),
                child: Row(
                  children: [
                    Text(stationState.trainName),
                    const SizedBox(width: 20),
                    Text(stationState.imageCode),
                  ],
                ),
              ),
              Text(stationState.stationName),
              Text(stationState.posterPosition),
              Text(getDate),
            ],
          ),
        ),
        (getDate == '')
            ? const Icon(
                Icons.check_box_outline_blank,
                color: Colors.transparent,
              )
            : IconButton(
                onPressed: () {
                  StationInfoDialog(
                    context: _context,
                    widget: StationInfoAlert(stamp: stationState),
                  );
                },
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
      ],
    );
  }
}
