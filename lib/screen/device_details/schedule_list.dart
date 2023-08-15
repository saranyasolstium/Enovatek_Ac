class SheduleItem {
  final String header;
  final List<String> schedules; // Store multiple schedules
  bool isExpanded;

  SheduleItem({required this.header, required this.schedules, this.isExpanded = false});
}