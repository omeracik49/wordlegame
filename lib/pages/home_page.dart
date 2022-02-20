import 'package:flutter/material.dart';
import 'package:wordleapp/models/steps.dart';
import 'package:wordleapp/widget/decoration_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String word = "ömera".toUpperCase();
  int stage = 0;
  var trueText = "Kelimeyi Doğru Tahmin Ettiniz";
  var falseText = "Kelimeyi Doğru Tahmin Edemediniz";
  var falseTitle = "Üzgünüm";
  var trueTitle = "Tebrikler";
  var closeText = 'Kapat';
  var title = "Wordle";
  String getText(int i) =>
      steps[5 * stage + i].textEditingController.text.toUpperCase().trim();
  setDecoration(InputDecoration decoration, int i) {
    steps[currentIndex(i)].inputDecoration = decoration;
  }

  setDisabledDecoration(InputDecoration decoration, int i) {
    steps[i].inputDecoration = decoration;
  }

  int currentIndex(int i) => 5 * stage + i;

  @override
  void initState() {
    super.initState();
    generateSteps();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: steps.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(
                    height: size.height * 0.8,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisExtent: 100,
                        childAspectRatio: 4,
                      ),
                      itemCount: steps.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: true,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                steps[index].textEditingController.text =
                                    value.toUpperCase();
                              });
                            },
                            maxLength: 1,
                            decoration: steps[index].inputDecoration,
                            controller: steps[index].textEditingController,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            String text = "";
                            int index = 0;
                            setState(() {
                              for (var i = 0; i < 5; i++) {
                                text += getText(i);
                                if (word[i] == getText(i)) {
                                  setDecoration(decoration(Colors.green), i);
                                } else if (getText(i).isNotEmpty) {
                                  if (word.contains(getText(i))) {
                                    setDecoration(
                                        decoration(Colors.yellowAccent), i);
                                  } else {
                                    setDecoration(decoration(Colors.red), i);
                                  }
                                } else {
                                  setDecoration(decoration(Colors.red), i);
                                }
                                index = i;
                              }
                            });
                            if (stage == 5) {
                              if (word == text) {
                                await _showDialog(trueTitle, trueText);
                              } else {
                                await _showDialog(falseTitle, falseText);
                              }
                            } else {
                              if (word == text) {
                                for (int i = currentIndex(index) + 1;
                                    i < steps.length;
                                    i++) {
                                  setDisabledDecoration(decoration(null), i);
                                }
                                await _showDialog(trueTitle, trueText);
                              }
                            }
                            if (stage < 5) {
                              stage++;
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Check"),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            setState(() {
                              generateSteps();
                              stage = 0;
                            });
                          },
                          icon: const Icon(Icons.restart_alt),
                          label: const Text("Restart"),
                        ),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Future<void> _showDialog(String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(closeText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
