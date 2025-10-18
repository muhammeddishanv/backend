import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.home_outlined,
      Icons.play_circle_outline,
      Icons.tune,
      Icons.person_outline,
    ];

    final List<String> labels = ["Home", "Subjects", "More", "Profile"];

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, icons, labels),
            _navItem(1, icons, labels),
            const SizedBox(width: 50), // Space for FAB
            _navItem(2, icons, labels),
            _navItem(3, icons, labels),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, List<IconData> icons, List<String> labels) {
    final isSelected = currentIndex == index;
    return InkWell(
      radius: 45,
      borderRadius: BorderRadius.circular(22.5),
      splashFactory: InkRipple.splashFactory,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[index],
              color: isSelected ? Colors.black : Colors.blueGrey,
            ),
            Text(
              labels[index],
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.blueGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
