import 'package:evendly_app/features/events/models/event_filter.dart';
import 'package:evendly_app/features/events/models/event_model.dart';
import 'package:evendly_app/features/home/services/event_filtering.dart';
import 'package:flutter_test/flutter_test.dart';

EventModel event({
  required String id,
  required String category,
  required int price,
  bool global = false,
  bool tickets = true,
  String location = 'Jakarta',
}) => EventModel(
  eventId: id,
  title: id,
  category: category,
  categoryKey: category.toLowerCase(),
  startAt: DateTime(2026),
  locationName: location,
  price: price,
  isGlobal: global,
  imageAsset: '',
  about: '',
  organizer: const OrganizerModel(name: '', avatar: ''),
  lat: 0,
  lng: 0,
  ticketAvailable: tickets,
);

void main() {
  final events = [
    event(id: 'music-local', category: 'Music', price: 100000),
    event(id: 'film-global', category: 'Film', price: 0, global: true),
    event(
      id: 'music-sold-out',
      category: 'Music',
      price: 250000,
      tickets: false,
      location: 'Bandung',
    ),
  ];

  test('combines category, ticket, and price filters', () {
    final result = filterEvents(
      events,
      const EventFilter(category: 'music', onlyTickets: true, maxPrice: 150000),
    );
    expect(result.map((event) => event.eventId), ['music-local']);
  });

  test('filters the optional nearby city without a Firestore query', () {
    final result = filterEvents(
      events,
      const EventFilter(nearMe: true),
      city: 'bandung',
    );
    expect(result.single.eventId, 'music-sold-out');
  });

  test('keeps nearby filtering usable when location is unavailable', () {
    final result = filterEvents(events, const EventFilter(nearMe: true));
    expect(result, hasLength(events.length));
  });
}
