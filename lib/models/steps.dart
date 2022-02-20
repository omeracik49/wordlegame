import 'package:flutter/material.dart';

class Steps {
  int index;
  TextEditingController textEditingController;
  InputDecoration inputDecoration;
  Steps(this.index, this.inputDecoration, this.textEditingController);
}

List<Steps> steps = [];
generateSteps() {
  steps = List.generate(
    30,
    (index) => Steps(
      index,
      const InputDecoration(
        border: OutlineInputBorder(),
      ),
      TextEditingController(text: ""),
    ),
  ).toList();
}
