import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationCountdown extends ConsumerStatefulWidget {
  const RecommendationCountdown({Key? key}) : super(key: key);

  @override
  ConsumerState<RecommendationCountdown> createState() => _RecommendationCountdownState();
}

class _RecommendationCountdownState extends ConsumerState<RecommendationCountdown> {
  late Timer _timer;
  Duration _duration = const Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final now = DateTime.now();
    final nextRefresh = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    _duration = nextRefresh.difference(now);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          _duration = const Duration(seconds: 0);
        });
      } else {
        setState(() {
          _duration -= const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "See New People in ${_formatDuration(_duration)}",
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
