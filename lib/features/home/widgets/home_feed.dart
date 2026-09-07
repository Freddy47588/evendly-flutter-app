import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../events/models/event_filter.dart';
import '../../events/models/event_model.dart';
import '../../events/pages/event_detail_page.dart';
import '../../events/pages/events_list_page.dart';
import '../../events/repositories/event_repository.dart';
import '../models/home_category.dart';
import '../services/event_filtering.dart';

class HomeFeed extends StatelessWidget {
  final TextEditingController searchController;
  final PageController popularController;
  final List<HomeCategory> categories;
  final int selectedCategory;
  final EventFilter filter;
  final EventRepository repository;
  final UserLocationData? userLocation;
  final ValueChanged<int> onCategorySelected;
  final VoidCallback onSearch;
  final VoidCallback onFilter;

  const HomeFeed({
    super.key,
    required this.searchController,
    required this.popularController,
    required this.categories,
    required this.selectedCategory,
    required this.filter,
    required this.repository,
    required this.userLocation,
    required this.onCategorySelected,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _HomeColors.of(context);
    return ColoredBox(
      color: colors.background,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          120,
        ),
        children: [
          _HomeHeader(location: userLocation, colors: colors),
          const SizedBox(height: AppSpacing.md),
          _SearchControls(
            controller: searchController,
            colors: colors,
            onSearch: onSearch,
            onFilter: onFilter,
          ),
          const SizedBox(height: AppSpacing.md),
          _CategoryChips(
            categories: categories,
            selectedIndex: selectedCategory,
            colors: colors,
            onSelected: onCategorySelected,
          ),
          const SizedBox(height: AppSpacing.lg),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: repository.watchEvents(limit: 80),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _StatusState(
                  message: 'We could not load events. Please try again.',
                  colors: colors,
                  icon: Icons.cloud_off_outlined,
                );
              }
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final events = filterEvents(
                snapshot.data!.docs.map(EventModel.fromDoc),
                filter,
                city: userLocation?.city ?? '',
              );
              if (events.isEmpty) {
                return _StatusState(
                  message:
                      'No events found. Try changing your category or filters.',
                  colors: colors,
                  icon: Icons.event_busy_outlined,
                );
              }
              return _EventSections(
                events: events,
                controller: popularController,
                colors: colors,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final UserLocationData? location;
  final _HomeColors colors;
  const _HomeHeader({required this.location, required this.colors});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location == null
                  ? 'Location'
                  : 'Location • ${location!.addressLine}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: colors.secondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.place, size: 18, color: colors.brand),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location?.city ?? 'Getting your location…',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      IconButton.outlined(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
        icon: const Icon(Icons.notifications_none),
        tooltip: 'Notifications',
      ),
    ],
  );
}

class _SearchControls extends StatelessWidget {
  final TextEditingController controller;
  final _HomeColors colors;
  final VoidCallback onSearch;
  final VoidCallback onFilter;
  const _SearchControls({
    required this.controller,
    required this.colors,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          controller: controller,
          readOnly: true,
          onTap: onSearch,
          decoration: InputDecoration(
            hintText: 'Search events, venues, artists…',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(color: colors.border),
            ),
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      SizedBox(
        height: 52,
        width: 52,
        child: FilledButton(
          onPressed: onFilter,
          style: FilledButton.styleFrom(
            backgroundColor: colors.brand,
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.tune),
        ),
      ),
    ],
  );
}

class _CategoryChips extends StatelessWidget {
  final List<HomeCategory> categories;
  final int selectedIndex;
  final _HomeColors colors;
  final ValueChanged<int> onSelected;
  const _CategoryChips({
    required this.categories,
    required this.selectedIndex,
    required this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final item = categories[index];
        final selected = index == selectedIndex;
        return ChoiceChip(
          avatar: Icon(
            item.icon,
            size: 18,
            color: selected ? Colors.white : colors.secondary,
          ),
          label: Text(item.label),
          selected: selected,
          selectedColor: colors.brand,
          labelStyle: TextStyle(
            color: selected ? Colors.white : colors.primary,
            fontWeight: FontWeight.w700,
          ),
          onSelected: (_) => onSelected(index),
        );
      },
    ),
  );
}

class _EventSections extends StatelessWidget {
  final List<EventModel> events;
  final PageController controller;
  final _HomeColors colors;
  const _EventSections({
    required this.events,
    required this.controller,
    required this.colors,
  });

  void _open(BuildContext context, EventModel event) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => EventDetailPage(event: event)),
  );
  void _seeAll(BuildContext context, String title, List<EventModel> list) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventsListPage(title: title, events: list),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final upcoming = events.take(6).toList();
    final popular = events
        .where((event) => event.ticketAvailable)
        .take(8)
        .toList();
    final recommended = events.skip(2).take(10).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Upcoming events',
          onSeeAll: () => _seeAll(context, 'Upcoming Events', events),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: upcoming.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, index) => _CompactEventCard(
              event: upcoming[index],
              colors: colors,
              onTap: () => _open(context, upcoming[index]),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionTitle(
          title: 'Popular now',
          onSeeAll: () => _seeAll(context, 'Popular Now', popular),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (popular.isEmpty)
          _InlineEmpty(
            colors: colors,
            message: 'No bookable events are available right now.',
          )
        else
          SizedBox(
            height: 292,
            child: PageView.builder(
              controller: controller,
              itemCount: popular.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: _FeatureEventCard(
                  event: popular[index],
                  colors: colors,
                  onTap: () => _open(context, popular[index]),
                ),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        _SectionTitle(
          title: 'Recommended for you',
          onSeeAll: () => _seeAll(context, 'Recommendations', recommended),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...recommended.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _RecommendedTile(
              event: event,
              colors: colors,
              onTap: () => _open(context, event),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionTitle({required this.title, required this.onSeeAll});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      TextButton(onPressed: onSeeAll, child: const Text('See all')),
    ],
  );
}

class _StatusState extends StatelessWidget {
  final String message;
  final _HomeColors colors;
  final IconData icon;
  const _StatusState({
    required this.message,
    required this.colors,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(28),
    child: Column(
      children: [
        Icon(icon, size: 36, color: colors.secondary),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: colors.secondary),
        ),
      ],
    ),
  );
}

class _InlineEmpty extends StatelessWidget {
  final _HomeColors colors;
  final String message;
  const _InlineEmpty({required this.colors, required this.message});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Text(message, style: TextStyle(color: colors.secondary)),
  );
}

class _CompactEventCard extends StatelessWidget {
  final EventModel event;
  final _HomeColors colors;
  final VoidCallback onTap;
  const _CompactEventCard({
    required this.event,
    required this.colors,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 295,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _EventImage(event: event, width: 88, height: double.infinity),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _EventCopy(event: event, colors: colors),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FeatureEventCard extends StatelessWidget {
  final EventModel event;
  final _HomeColors colors;
  final VoidCallback onTap;
  const _FeatureEventCard({
    required this.event,
    required this.colors,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EventImage(event: event, width: double.infinity, height: 160),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: _EventCopy(
                event: event,
                colors: colors,
                showLocation: true,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _RecommendedTile extends StatelessWidget {
  final EventModel event;
  final _HomeColors colors;
  final VoidCallback onTap;
  const _RecommendedTile({
    required this.event,
    required this.colors,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            _EventImage(event: event, width: 68, height: 68),
            const SizedBox(width: 10),
            Expanded(
              child: _EventCopy(
                event: event,
                colors: colors,
                showLocation: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EventImage extends StatelessWidget {
  final EventModel event;
  final double width;
  final double height;
  const _EventImage({
    required this.event,
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: const Icon(Icons.event),
    );
    final path = event.imageAsset;
    return SizedBox(
      width: width,
      height: height,
      child: path.isEmpty
          ? placeholder
          : path.startsWith('http')
          ? Image.network(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            )
          : Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}

class _EventCopy extends StatelessWidget {
  final EventModel event;
  final _HomeColors colors;
  final bool showLocation;
  const _EventCopy({
    required this.event,
    required this.colors,
    this.showLocation = false,
  });
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM • HH:mm', 'en_US').format(event.startAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          date,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: colors.secondary),
        ),
        if (showLocation) ...[
          const SizedBox(height: 4),
          Text(
            event.locationName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: colors.secondary),
          ),
        ],
        const SizedBox(height: 5),
        Text(
          event.price <= 0 ? 'Free' : 'Rp ${event.price}',
          style: AppTextStyles.caption.copyWith(
            color: colors.brand,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HomeColors {
  final Color background;
  final Color surface;
  final Color border;
  final Color primary;
  final Color secondary;
  final Color brand;
  const _HomeColors({
    required this.background,
    required this.surface,
    required this.border,
    required this.primary,
    required this.secondary,
    required this.brand,
  });
  factory _HomeColors.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return _HomeColors(
      background: dark ? Colors.black : Colors.white,
      surface: dark ? AppColors.darkSurface : const Color(0xFFF6F7F9),
      border: dark ? AppColors.darkBorder : AppColors.lightBorder,
      primary: dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      secondary: dark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
      brand: dark ? AppColors.darkPrimary : AppColors.lightPrimary,
    );
  }
}
