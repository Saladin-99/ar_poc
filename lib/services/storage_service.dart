import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dot.dart';

class StorageService {
  static const String _dotsKey = 'saved_dots';

  Future<void> saveDot(Dot dot) async {
    final prefs = await SharedPreferences.getInstance();
    final savedDots = await getSavedDots();
    savedDots.add(dot);
    await prefs.setString(
        _dotsKey, jsonEncode(savedDots.map((d) => d.toJson()).toList()));
  }

  Future<List<Dot>> getSavedDots() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dotsJson = prefs.getString(_dotsKey);
    if (dotsJson == null) return [];
    final List<dynamic> dotsData = jsonDecode(dotsJson);
    return dotsData.map((data) => Dot.fromJson(data)).toList();
  }
}
