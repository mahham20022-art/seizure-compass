/// One entry in the searchable Seizure Atlas (Module 3).
class SeizureLibraryEntry {
  const SeizureLibraryEntry({
    required this.name,
    required this.category,
    required this.summary,
    required this.keyFeatures,
    required this.eeg,
    this.pearl,
    this.isRare = false,
  });

  final String name;

  /// Free-text grouping shown as a tag, e.g. "Focal", "Generalized",
  /// "Epilepsy syndrome", "Reflex epilepsy", "Mimic".
  final String category;
  final String summary;
  final List<String> keyFeatures;
  final String eeg;
  final String? pearl;

  /// Flags rare/genetic epilepsy syndromes shown under the Atlas's
  /// "Rare types" filter.
  final bool isRare;

  /// Combined text used by the library search box.
  String get searchText =>
      '$name $category $summary ${keyFeatures.join(' ')}'.toLowerCase();
}
