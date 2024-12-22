import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      GridItem(icon: Icons.star, label: 'Irshadat', route: '/irshadat'),
      GridItem(icon: Icons.settings, label: 'Settings', route: '/settings'),
      GridItem(icon: Icons.person, label: 'Profile', route: '/profile'),
      GridItem(
          icon: Icons.notifications,
          label: 'Notifications',
          route: '/notifications'),
      GridItem(icon: Icons.help, label: 'Help', route: '/help'),
      GridItem(icon: Icons.info, label: 'About', route: '/about'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("PANJATAN"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            return AnimatedGridItem(
              item: gridItems[index],
            );
          },
        ),
      ),
    );
  }
}

class GridItem {
  final IconData icon;
  final String label;
  final String route;

  GridItem({required this.icon, required this.label, required this.route});
}

class AnimatedGridItem extends StatelessWidget {
  final GridItem item;

  const AnimatedGridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
