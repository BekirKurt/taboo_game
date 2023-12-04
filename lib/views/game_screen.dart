import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taboo_game/riverpod/riverpod_managment.dart';
import 'package:taboo_game/views/start_screen.dart';
import 'package:timer_count_down/timer_count_down.dart';

class GameScreen extends StatelessWidget {
  final String teamAName;
  final String teamBName;
  final double timeValue;
  final double passValue;

  const GameScreen({
    required this.teamAName,
    required this.teamBName,
    required this.timeValue,
    required this.passValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Container(
              alignment: Alignment.center, child: const Text('Başlama ekranı')),
          content: SizedBox(
            height: 40,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                  textAlign: TextAlign.center,
                  "Oyun başlamak için tıklayınız."),
            ),
          ),
          actions: [
            Consumer(
              builder: (ctx, ref, child) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.watch(wordsProvider.notifier).controller.start();
                  },
                  child: const Text('Başla'),
                );
              },
            )
          ],
        ),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(25),
          color: const Color(0xFFDADDB1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 632,
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: Consumer(
                        builder: (ctx, ref, child) {
                          return ElevatedButton(
                              onPressed: () {
                                ref.watch(wordsProvider.notifier).controller.pause();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                    title: Container(
                                      alignment: Alignment.center,
                                      child: const Text('Oyun duraklatıldı'),
                                    ),
                                    content: SizedBox(
                                      height: 40,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Takım $teamAName : ${ref.watch(wordsProvider.notifier).teamATotalScore}  ",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "Takım $teamBName : ${ref.watch(wordsProvider.notifier).teamBTotalScore} ",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:BorderRadius.circular(16.0),
                                                    ),
                                                    title: Container(
                                                        alignment:Alignment.center,
                                                        child: const Text('Oyun ayarları')),
                                                    content: SizedBox(
                                                      height: 40,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment.center,
                                                            child: const Text(
                                                                "Ayarlara gitmek istediğinizden emin misiniz? Oyun tekrardan başlatılacak"),
                                                                textAlign:TextAlign.center,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {Navigator.pop(context);},
                                                          child: const Text("İptal")),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          ref.watch(wordsProvider.notifier).resetGame();
                                                          Navigator.push(context,MaterialPageRoute(builder:(context) =>const StartScreen()));
                                                        },
                                                        child:const Text('Evet'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: const Text("Ayarlar")),
                                          ElevatedButton(
                                            onPressed: () {
                                              ref.watch(wordsProvider.notifier).controller.resume();
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Devam et'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text("Durdur"));
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer(
                              builder: (ctx, ref, child) {
                                final score = ref.watch(wordsProvider);
                                return Text(
                                  "Skor : ${score.score} ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Consumer(
                              builder: (ctx, ref, child) {
                                final passValue = ref.watch(wordsProvider);
                                return Text(
                                  "Pas hakkı : ${passValue.passValue}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)
                                );
                              },
                            )
                          ],
                        ),
                        Consumer(
                          builder: (ctx, ref, child) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 200,
                                    child: Consumer(
                                      builder: (ctx, watch, child) {
                                        final currentTeam = ref.watch(wordsProvider);
                                        return Text(
                                          currentTeam.whichTeam
                                              ? "Takım : $teamAName"
                                              : "Takım : $teamBName",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Countdown(
                                    controller: ref.watch(wordsProvider.notifier).controller,
                                    seconds: timeValue.round(),
                                    build:
                                        (BuildContext context, double time) =>
                                            Text("Zaman : ${time.round().toString()}",
                                          style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    interval: const Duration(milliseconds: 100),
                                    onFinished: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(16.0),
                                          ),
                                          title: Container(
                                              alignment: Alignment.center,
                                              child: const Text('Süre doldu')),
                                          content: SizedBox(
                                            height: 40,
                                            child: Column(
                                              children: [
                                                Text("$teamAName : ${ref.watch(wordsProvider.notifier).teamATotalScore}"),
                                                Text("$teamBName : ${ref.watch(wordsProvider.notifier).teamBTotalScore}"),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                ref.watch(wordsProvider.notifier).setScore();
                                                ref.watch(wordsProvider.notifier).setPassValue = passValue.round();
                                                ref.watch(wordsProvider.notifier).whichTeam = !ref.watch(wordsProvider.notifier).whichTeam;
                                                ref.watch(wordsProvider.notifier).controller.restart();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Sıradaki takım'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    color: const Color(0xFF557153),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(
                          builder: (ctx, ref, child) {
                            final mainWord = ref.watch(wordsProvider);
                            return Text(
                              mainWord.selectedWord.mainWord,
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final yasakliKelimeler = ref.watch(wordsProvider);
                      return Container(
                        color: const Color(0xFF7D8F69),
                        child: Column(
                          children: [
                            for (var i = 0;i < yasakliKelimeler.selectedWord.tabooWords.length;i++)
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF557153),
                                            width: 0.6))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 22),
                                      child: Text(
                                        yasakliKelimeler.selectedWord.tabooWords[i],
                                        style: const TextStyle(color: Colors.white, fontSize: 16)
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Consumer(
                          builder: (ctx, ref, child) {
                            return ElevatedButton(
                              onPressed: () {
                                ref.watch(wordsProvider.notifier).tabooFun();
                              },
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade600)),
                              child: const Text("Tabu"),
                            );
                          },
                        ),
                        Consumer(
                          builder: (ctx, ref, child) {
                            return ElevatedButton(
                              onPressed: () {
                                ref.watch(wordsProvider.notifier).passFun();
                                if (ref.watch(wordsProvider.notifier).passValue == 0) {
                                  _showSnackbar(context, "Pas hakkınız doldu");
                                }
                              },
                              child: const Text("Pas"),
                            );
                          },
                        ),
                        Consumer(
                          builder: (ctx, ref, child) {
                            return ElevatedButton(
                              onPressed: () {
                                ref.watch(wordsProvider.notifier).correctFun();
                              },
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7D8F69),
                                  )),
                              child: const Text("Doğru"),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        content: Text(message),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Tamam',
          onPressed: () {},
        ),
      ),
    );
  }
}
