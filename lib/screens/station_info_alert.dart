import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../extensions/extensions.dart';
import '../model/station_stamp.dart';

class StationInfoAlert extends ConsumerWidget {
  const StationInfoAlert({super.key, required this.stamp});

  final StationStamp stamp;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image =
        'http://toyohide.work/BrainLog/station_stamp/${stamp.imageFolder}/${stamp.imageCode}.png';

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stamp.stationName),
                    Text(stamp.trainName),
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(0.4),
                  thickness: 2,
                ),
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/no_image.png',
                  image: image,
                  imageErrorBuilder: (c, o, s) =>
                      Image.asset('assets/images/no_image.png'),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.4),
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text('${stamp.stampGetDate} 取得'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
