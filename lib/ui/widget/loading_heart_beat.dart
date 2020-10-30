import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LoadingHeartBeat extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const LoadingHeartBeat({
    this.width = 50,
    this.height = 50,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FlareActor(
        'assets/flare/heart_beat_loading.flr',
        animation: 'loading',
        color: color,
      ),
    );
  }
}
