class Supplication {
  final String arabicText;
  final String virtueMyanmar;
  final String notesMyanmar; // Add this line

  Supplication({
    required this.arabicText,
    required this.virtueMyanmar,
    this.notesMyanmar = '', // Initialize with empty string
  });

  factory Supplication.fromJson(Map<String, dynamic> json) {
    return Supplication(
      arabicText: json['arabic'],
      virtueMyanmar: json['virtue_myanmar'],
      notesMyanmar: json['notes_myanmar'] ?? '', // Handle potential null
    );
  }
}