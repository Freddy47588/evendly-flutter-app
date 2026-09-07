import 'package:evendly_app/features/events/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses map data into normalized event fields', () {
    final event = EventModel.fromMap({
      'title': 'Jazz in the Park',
      'category': '  Music ',
      'startAt': '2026-05-10T19:30:00.000',
      'price': '125000',
      'isGlobal': true,
      'organizer': {'name': 'Evendly Music', 'avatar': 'avatar.png'},
      'map': {'lat': -6.2088, 'lng': 106.8456},
      'ticketAvailable': true,
    }, documentId: 'event-123');

    expect(event.eventId, 'event-123');
    expect(event.categoryKey, 'music');
    expect(event.startAt, DateTime(2026, 5, 10, 19, 30));
    expect(event.price, 125000);
    expect(event.organizer.name, 'Evendly Music');
    expect(event.mapLat, -6.2088);
    expect(event.mapLng, 106.8456);
    expect(event.ticketAvailable, isTrue);
  });
}
