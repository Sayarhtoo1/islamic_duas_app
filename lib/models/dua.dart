import 'package:islamic_duas_app/models/supplication.dart';

class Dua {
  final int id;
  final String titleMyanmar;
  final String categoryMyanmar;
  final String narrationMyanmar;
  final List<Supplication> supplications;
  final String source;
  final String notesMyanmar;

  Dua({
    required this.id,
    required this.titleMyanmar,
    required this.categoryMyanmar,
    required this.narrationMyanmar,
    required this.supplications,
    required this.source,
    required this.notesMyanmar,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    var supplicationsList = json['duas'] as List;
    List<Supplication> supplications = supplicationsList
        .map((s) => Supplication.fromJson(s))
        .toList();

    return Dua(
      id: json['id'],
      titleMyanmar: json['title_myanmar'],
      categoryMyanmar: json['category_myanmar'],
      narrationMyanmar: json['narration_myanmar'],
      supplications: supplications,
      source: json['source'],
      notesMyanmar: json['notes_myanmar'],
    );
  }
}