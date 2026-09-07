import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../events/models/event_filter.dart';

class HomeFilterSheet extends StatefulWidget {
  final EventFilter initial;
  final String currentCity;

  const HomeFilterSheet({
    super.key,
    required this.initial,
    required this.currentCity,
  });

  @override
  State<HomeFilterSheet> createState() => _HomeFilterSheetState();
}

class _HomeFilterSheetState extends State<HomeFilterSheet> {
  late EventFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : Colors.white;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final primary = dark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondary = dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final brand = dark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.paddingOf(context).bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: dark ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              color: secondary.withValues(alpha: .3),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Filter events',
            style: AppTextStyles.h3.copyWith(color: primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Scope',
            style: AppTextStyles.caption.copyWith(color: secondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            children: [
              _scopeChip('All', _filter.isGlobal == null, () {
                setState(() => _filter = _filter.copyWith(clearScope: true));
              }),
              _scopeChip('Local', _filter.isGlobal == false, () {
                setState(() => _filter = _filter.copyWith(isGlobal: false));
              }),
              _scopeChip('Global', _filter.isGlobal == true, () {
                setState(() => _filter = _filter.copyWith(isGlobal: true));
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: Rp ${_filter.minPrice} – Rp ${_filter.maxPrice}',
                  style: AppTextStyles.body.copyWith(color: primary),
                ),
                RangeSlider(
                  min: 0,
                  max: 6000000,
                  divisions: 60,
                  values: RangeValues(
                    _filter.minPrice.toDouble(),
                    _filter.maxPrice.toDouble(),
                  ),
                  onChanged: (values) => setState(() {
                    _filter = _filter.copyWith(
                      minPrice: values.start.round(),
                      maxPrice: values.end.round(),
                    );
                  }),
                ),
              ],
            ),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _filter.onlyTickets,
            onChanged: (value) =>
                setState(() => _filter = _filter.copyWith(onlyTickets: value)),
            title: const Text('Available tickets only'),
            subtitle: const Text('Show events that can be booked now.'),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _filter.nearMe,
            onChanged: (value) =>
                setState(() => _filter = _filter.copyWith(nearMe: value)),
            title: const Text('Near me'),
            subtitle: Text(
              widget.currentCity.isEmpty
                  ? 'Enable location to filter by city.'
                  : 'Filter by ${widget.currentCity}.',
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      setState(() => _filter = const EventFilter()),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _filter),
                  style: FilledButton.styleFrom(backgroundColor: brand),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scopeChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
