// ignore_for_file: must_be_immutable, cascade_invocations, avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:station_stamp/screens/station_info_alert.dart';
import 'package:station_stamp/screens/station_info_dialog.dart';

import '../extensions/extensions.dart';
import '../model/station_stamp.dart';
import '../utility/utility.dart';
import '../viewmodel/station_stamp_notifier.dart';

class StampScreen extends ConsumerWidget {
  StampScreen({super.key, required this.trainName});

  final String trainName;

  final Utility _utility = Utility();

  List<StationStamp> stampList = [];

  late WidgetRef _ref;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    makeStampList();

    final imageWidth = context.screenSize.width * 0.3;

    return Stack(
      fit: StackFit.expand,
      children: [
        _utility.getBackGround(),
        CustomScrollView(
          slivers: <Widget>[
            SliverGrid.count(
              crossAxisCount: 2,
              children: (stampList.isEmpty)
                  ? [Container()]
                  : List.generate(
                      stampList.length,
                      (index) {
                        final image =
                            'http://toyohide.work/BrainLog/station_stamp/${stampList[index].imageFolder}/${stampList[index].imageCode}.png';

                        final getflag = (stampList[index].stampGetDate == '')
                            ? false
                            : true;

                        return Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          child: Column(
                            children: [
                              //

                              const SizedBox(height: 10),

                              //

                              GestureDetector(
                                onTap: () =>
                                    (stampList[index].stampGetDate == '')
                                        ? null
                                        : StationInfoDialog(
                                            context: context,
                                            widget: StationInfoAlert(
                                                stamp: stampList[index]),
                                          ),
                                child: SizedBox(
                                  height: imageWidth,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/no_image.png',
                                    image: image,
                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                        'assets/images/no_image.png'),
                                  ),
                                ),
                              ),

                              //

                              const SizedBox(height: 10),

                              //

                              SizedBox(
                                width: 150,
                                height: 40,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 150,
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        stampList[index].imageCode,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: getflag
                                              ? Colors.yellowAccent
                                                  .withOpacity(0.6)
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      stampList[index].stationName,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),

                              //
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ],
    );
  }

  ///
  void makeStampList() {
    final stationStampState = _ref.watch(stationStampProvider);

    stationStampState.forEach((element) {
      if (trainName == element.trainName) {
        stampList.add(element);
      }
    });
  }
}
