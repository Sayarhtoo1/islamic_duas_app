import 'package:flutter/foundation.dart';
import 'package:islamic_duas_app/models/dua.dart';

class FavoriteDuaProvider with ChangeNotifier {
  final List<Dua> _favoriteDuas = [];

  List<Dua> get favoriteDuas => _favoriteDuas;

  void toggleFavorite(Dua dua) {
    if (_favoriteDuas.contains(dua)) {
      _favoriteDuas.remove(dua);
    } else {
      _favoriteDuas.add(dua);
    }
    notifyListeners();
  }

  bool isFavorite(Dua dua) {
    return _favoriteDuas.contains(dua);
  }
}