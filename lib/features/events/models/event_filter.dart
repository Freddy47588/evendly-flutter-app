class EventFilter {
  final String category;
  final bool? isGlobal;
  final bool onlyTickets;
  final bool nearMe;
  final int minPrice;
  final int maxPrice;

  const EventFilter({
    this.category = '',
    this.isGlobal,
    this.onlyTickets = false,
    this.nearMe = false,
    this.minPrice = 0,
    this.maxPrice = 6000000,
  });

  EventFilter copyWith({
    String? category,
    bool? isGlobal,
    bool clearScope = false,
    bool? onlyTickets,
    bool? nearMe,
    int? minPrice,
    int? maxPrice,
  }) {
    return EventFilter(
      category: category ?? this.category,
      isGlobal: clearScope ? null : (isGlobal ?? this.isGlobal),
      onlyTickets: onlyTickets ?? this.onlyTickets,
      nearMe: nearMe ?? this.nearMe,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}
