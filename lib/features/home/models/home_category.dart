import 'package:flutter/material.dart';

class HomeCategory {
  final String label;
  final IconData icon;

  const HomeCategory(this.label, this.icon);
}

const homeCategories = [
  HomeCategory('All', Icons.apps),
  HomeCategory('Music', Icons.music_note),
  HomeCategory('Education', Icons.school),
  HomeCategory('Film', Icons.movie),
  HomeCategory('Sports', Icons.sports_soccer),
  HomeCategory('Art', Icons.brush),
];
