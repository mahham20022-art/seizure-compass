/// Qualitative strength label shown as a badge on each pearl flashcard.
/// These are teaching-heuristic tiers, not a formal GRADE/level-of-evidence
/// system — Seizure Compass pearls are not a graded systematic review.
enum EvidenceLevel { classic, supportive, expert }

extension EvidenceLevelX on EvidenceLevel {
  String get label {
    switch (this) {
      case EvidenceLevel.classic:
        return 'Classic teaching sign';
      case EvidenceLevel.supportive:
        return 'Supportive feature';
      case EvidenceLevel.expert:
        return 'Expert consensus';
    }
  }
}

/// A single short, evidence-based teaching note (Module 4), shown as a
/// flashcard: a short [title] (the key message) plus a one-line
/// [text] explanation.
class ClinicalPearl {
  const ClinicalPearl({
    required this.category,
    required this.title,
    required this.text,
    this.level = EvidenceLevel.supportive,
  });

  final String category;
  final String title;
  final String text;
  final EvidenceLevel level;
}
