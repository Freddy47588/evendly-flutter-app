import '../../events/models/event_filter.dart';
import '../../events/models/event_model.dart';

/// Applies discovery filters locally to keep Firestore queries index-free.
/// The events collection remains a realtime stream; filters only shape its UI.
List<EventModel> filterEvents(
  Iterable<EventModel> source,
  EventFilter filter, {
  String city = '',
}) {
  return source.where((event) {
    final matchesCategory =
        filter.category.trim().isEmpty ||
        event.categoryKey == filter.category.trim().toLowerCase();
    final matchesScope =
        filter.isGlobal == null || event.isGlobal == filter.isGlobal;
    final matchesPrice =
        event.price >= filter.minPrice && event.price <= filter.maxPrice;
    final matchesTickets = !filter.onlyTickets || event.ticketAvailable;
    final matchesCity =
        !filter.nearMe ||
        city.trim().isEmpty ||
        event.locationName.toLowerCase().contains(city.trim().toLowerCase());
    return matchesCategory &&
        matchesScope &&
        matchesPrice &&
        matchesTickets &&
        matchesCity;
  }).toList();
}
