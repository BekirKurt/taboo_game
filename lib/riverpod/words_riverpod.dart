import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taboo_game/model/words.dart';
import 'package:timer_count_down/timer_controller.dart';

class Words extends ChangeNotifier {
  final List<TabuWords> _words = [];
  List<TabuWords> get words => _words;
  bool whichTeam = true;

  int randomNumber = 0;
  int teamATotalScore = 0;
  int teamBTotalScore = 0;

  int score = 0;
  void setScore() {
    score = 0;
    notifyListeners();
  }

  void resetGame() {
    teamATotalScore = 0;
    teamBTotalScore = 0;
    score = 0;
    whichTeam = true;
    //startGame = true;
  }

  int _passValue = 0;
  int get passValue => _passValue;
  set setPassValue(int sayi) {
    _passValue = sayi;
  }

  int _timeValue = 0;
  int get timeValue => _timeValue;

  TabuWords selectedWord = TabuWords(mainWord: "deneme", tabooWords: [
    "yasaklı kelime",
    "yasaklı kelime",
    "yasaklı kelime",
    "yasaklı kelime",
    "yasaklı kelime",
  ]);

  CountdownController controller = CountdownController();

  void startController() {
    controller.autoStart;
  }

  void updatGameInfos(double newPassValue, double newTimeValue) {
    _passValue = newPassValue.round();
    _timeValue = newTimeValue.round();
    notifyListeners();
  }

  int changeTabooQuestion() {
    randomNumber = Random().nextInt(135);
    selectedWord = words[randomNumber];
    notifyListeners();
    return randomNumber;
  }

  void correctFun() {
    if (whichTeam) {
      score++;
      teamATotalScore++;
    } else {
      score++;
      teamBTotalScore++;
    }

    changeTabooQuestion();
    notifyListeners();
  }

  void tabooFun() {
    if (whichTeam) {
      score--;
      teamATotalScore--;
    } else {
      score--;
      teamBTotalScore--;
    }
    changeTabooQuestion();
    notifyListeners();
  }

  void passFun() {
    if (passValue != 0) {
      _passValue--;
      changeTabooQuestion();
      notifyListeners();
    } else {}
  }

  Future<String> loadJsonData() async {
    return await rootBundle.loadString('assets/kelimeler.json');
  }

  Future<List> readJsonData(BuildContext context) async {
    try {
      String jsonData = await loadJsonData();
      Map<String, dynamic> data = json.decode(jsonData);

      List<dynamic> wordsData = data["kelimeler"];

      for (var item in wordsData) {
        _words.add(TabuWords.fromJson(item));
      }
      // print(wordsData);
      // print(_words[0].mainWord);
      return wordsData;
    } catch (e) {
      debugPrint('Error reading JSON: $e');
      return [];
    }
  }
}
