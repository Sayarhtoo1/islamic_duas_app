import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:islamic_duas_app/models/dua.dart';

class DuaService {
  Future<List<Dua>> loadDuas() async {
    final String response = await rootBundle.loadString('assets/duas.json');
    final data = await json.decode(response);
    return (data as List).map((json) => Dua.fromJson(json)).toList();
  }
}