import 'dart:ui' as r;

class Locale {
  const Locale({required this.languageCode, this.areaCode});

  factory Locale.from(String raw) {
    final full = raw.toLowerCase();
    for (final sep in ['-', '_']) {
      if (full.contains(sep)) {
        final parts = full.split(sep);
        return Locale(languageCode: parts[0], areaCode: parts[1]);
      }
    }
    return Locale(languageCode: full);
  }

  factory Locale.fromFrameLocale(r.Locale raw) =>
      Locale(languageCode: raw.languageCode, areaCode: raw.countryCode);

  final String languageCode;
  final String? areaCode;

  @override
  String toString() =>
      areaCode == null ? languageCode : '$languageCode-$areaCode';
}
