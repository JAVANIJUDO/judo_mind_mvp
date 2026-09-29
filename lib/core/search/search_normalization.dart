/// Produces a deterministic comparison value without changing stored content.
///
/// Persian/Arabic word separators and the most common Arabic keyboard letter
/// variants are normalized only for local search matching.
String normalizeSearchValue(String value) {
  final normalizedLetters = value
      .toLowerCase()
      .replaceAll('\u064a', '\u06cc') // Arabic yeh -> Persian yeh.
      .replaceAll('\u0649', '\u06cc') // Alef maksura -> Persian yeh.
      .replaceAll('\u0643', '\u06a9'); // Arabic kaf -> Persian kaf.
  return normalizedLetters
      .replaceAll(RegExp(r'[\s\u00a0\u200c\u200d\u202f\u2060]+'), ' ')
      .trim();
}
