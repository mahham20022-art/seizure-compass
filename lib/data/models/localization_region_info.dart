import 'enums.dart';

/// Static reference content for one lobe/region in the Localization
/// Explorer (Module 2).
class LocalizationRegionInfo {
  const LocalizationRegionInfo({
    required this.region,
    required this.typicalAura,
    required this.semiology,
    required this.eeg,
    required this.mri,
    required this.differentials,
  });

  final LocalizationRegion region;
  final List<String> typicalAura;
  final List<String> semiology;
  final String eeg;
  final String mri;
  final List<String> differentials;
}
