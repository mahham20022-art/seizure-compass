/// How confidently a historical/public figure's association with epilepsy
/// or seizures is established.
enum FigureConfidence { documented, historical }

extension FigureConfidenceX on FigureConfidence {
  String get label {
    switch (this) {
      case FigureConfidence.documented:
        return 'Documented / self-disclosed';
      case FigureConfidence.historical:
        return 'Historical — debated diagnosis';
    }
  }
}

/// A person historically or publicly associated with epilepsy/seizures,
/// shown in the Library's "Notable Figures" tab.
class NotableFigure {
  const NotableFigure({
    required this.name,
    required this.years,
    required this.description,
    required this.confidence,
  });

  final String name;
  final String years;
  final String description;
  final FigureConfidence confidence;
}
