import 'package:flutter/material.dart';

InputDecoration decoration(Color? color) {
  return InputDecoration(
    enabled: false,
    fillColor: color,
    filled: true,
    border: const OutlineInputBorder(),
  );
}
