/// One entry in the epilepsy history timeline (Library > History tab).
class HistoryEvent {
  const HistoryEvent({required this.era, required this.title, required this.description});

  final String era;
  final String title;
  final String description;
}
