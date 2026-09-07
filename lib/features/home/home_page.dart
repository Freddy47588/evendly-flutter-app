import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/location_service.dart';
import '../events/models/event_filter.dart';
import '../events/repositories/event_repository.dart';
import '../favourites/pages/favourite_page.dart';
import '../profile_setup/pages/profile_page.dart';
import '../search/search_page.dart';
import '../tickets/pages/tickets_page.dart';
import 'models/home_category.dart';
import 'widgets/evendly_bottom_bar.dart';
import 'widgets/home_feed.dart';
import 'widgets/home_filter_sheet.dart';

/// Owns home navigation, location lifecycle, and the selected discovery filter.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _popularController = PageController(viewportFraction: .80);
  final _events = EventRepository();
  final _location = LocationService();
  StreamSubscription<UserLocationData>? _locationSubscription;

  EventFilter _filter = const EventFilter();
  UserLocationData? _userLocation;
  int _selectedCategory = 0;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _location
        .start()
        .then((_) {
          _locationSubscription = _location.stream.listen((location) {
            if (mounted) setState(() => _userLocation = location);
          });
        })
        .catchError((_) {
          // Location is optional; discovery remains available without it.
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _popularController.dispose();
    _locationSubscription?.cancel();
    _location.stop();
    _location.dispose();
    super.dispose();
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategory = index;
      final category = homeCategories[index].label.toLowerCase();
      _filter = _filter.copyWith(category: category == 'all' ? '' : category);
    });
  }

  Future<void> _openFilters() async {
    final filter = await showModalBottomSheet<EventFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HomeFilterSheet(
        initial: _filter,
        currentCity: _userLocation?.city ?? '',
      ),
    );
    if (filter == null || !mounted) return;

    setState(() {
      _filter = filter;
      final category = filter.category.toLowerCase();
      _selectedCategory = homeCategories.indexWhere(
        (item) => item.label.toLowerCase() == category,
      );
      if (_selectedCategory < 0) _selectedCategory = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeed(
        searchController: _searchController,
        popularController: _popularController,
        categories: homeCategories,
        selectedCategory: _selectedCategory,
        filter: _filter,
        repository: _events,
        userLocation: _userLocation,
        onCategorySelected: _selectCategory,
        onSearch: () => setState(() => _selectedTab = 1),
        onFilter: _openFilters,
      ),
      const SearchPage(),
      const FavouritePage(),
      const TicketsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedTab, children: pages),
      ),
      bottomNavigationBar: EvendlyBottomBar(
        currentIndex: _selectedTab,
        onChanged: (index) => setState(() => _selectedTab = index),
      ),
    );
  }
}
