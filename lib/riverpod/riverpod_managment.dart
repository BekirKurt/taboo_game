import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taboo_game/riverpod/words_riverpod.dart';

final wordsProvider = ChangeNotifierProvider((_) => Words());
