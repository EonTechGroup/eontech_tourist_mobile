import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime expiresAt;

  const CountdownTimer({super.key, required this.expiresAt});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.expiresAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _remaining = widget.expiresAt.difference(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    if (_remaining.isNegative) {
      return const Text(
        'Expired',
        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
      );
    }

    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    final isUrgent = _remaining.inMinutes < 10;

    return Row(
      children: [
        Icon(
          Icons.timer_outlined,
          size: 14,
          color: isUrgent ? Colors.red : const Color(0xFFFF6B35),
        ),
        const SizedBox(width: 4),
        Text(
          hours > 0
              ? '${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}'
              : '${_pad(minutes)}:${_pad(seconds)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isUrgent ? Colors.red : const Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'left',
          style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }
}