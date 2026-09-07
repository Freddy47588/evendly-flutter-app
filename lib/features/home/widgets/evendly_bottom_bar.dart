import 'package:flutter/material.dart';

class EvendlyBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const EvendlyBottomBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final active = dark ? Colors.white : const Color(0xFF4FACFE);
    final inactive = dark ? Colors.white54 : Colors.black54;
    const icons = [
      Icons.home_outlined,
      Icons.search,
      Icons.favorite_border,
      Icons.confirmation_number_outlined,
      Icons.person_outline,
    ];

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 64,
        child: Row(
          children: List.generate(icons.length, (index) {
            final selected = currentIndex == index;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: selected ? 20 : 0,
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: active,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Icon(icons[index], color: selected ? active : inactive),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
