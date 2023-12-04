import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taboo_game/riverpod/riverpod_managment.dart';
import 'package:taboo_game/views/game_screen.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  final TextEditingController teamAName = TextEditingController();
  final TextEditingController teamBName = TextEditingController();
  double _timeValue = 60.0;
  double _passValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 40),
          child: Column(
            children: [
              const Text("Oyun Ayarları", style: TextStyle(fontSize: 29)),
              TextField(
                controller: teamAName,
                decoration: const InputDecoration(labelText: "Takım A İsmi"),
              ),
              TextField(
                controller: teamBName,
                decoration: const InputDecoration(labelText: "Takım B İsmi"),
              ),
              Slider(
                value: _timeValue,
                min: 60.0,
                max: 180.0,
                divisions: 4,
                onChanged: (value) {
                  setState(() {
                    _timeValue = value;
                  });
                },
              ),
              Text("Zaman :${_timeValue.round()}"),
              Slider(
                value: _passValue,
                min: 0.0,
                max: 7,
                divisions: 7,
                onChanged: (value) {
                  setState(() {
                    _passValue = value;
                  });
                },
              ),
              Text("Pas hakkı :${_passValue.round()}"),
              const SizedBox(
                height: 22,
              ),
              Consumer(
                builder: (ctx, ref, child) {
                  ref.watch(wordsProvider.notifier).readJsonData(context);
                  return ElevatedButton(
                    onPressed: () {
                      if (teamAName.text == "" ||
                          teamBName.text == "" ||
                          teamAName.text.length < 3 ||
                          teamBName.text.length < 3 ||
                          teamAName.text.length > 25 ||
                          teamBName.text.length > 25) {
                        _showSnackbar(context,
                            "Lütfen takım adlarını düzgün bir biçimde giriniz");
                      } else if (teamAName.text == teamBName.text) {
                        _showSnackbar(
                            context, "Takım isimlerini farklı giriniz");
                      } else {
                        ref
                            .read(wordsProvider.notifier)
                            .updatGameInfos(_passValue, _timeValue);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => GameScreen(
                                  teamAName: teamAName.text,
                                  teamBName: teamBName.text,
                                  timeValue: _timeValue,
                                  passValue: _passValue))),
                        );

                        ref.watch(wordsProvider.notifier).changeTabooQuestion();
                      }
                    },
                    child: const Text("Başla"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
