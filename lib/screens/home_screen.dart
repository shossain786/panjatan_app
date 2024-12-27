import 'package:flutter/material.dart';
import 'package:panjatan_app/screens/add_sawal_screen.dart';
import 'package:panjatan_app/widgets/app_background.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      GridItem(
          icon: Icons.star, label: 'Irshadat(ارشادات)', route: '/irshadat'),
      GridItem(
          icon: FlutterIslamicIcons.quran,
          label: 'Sawal O Jawab(سوالات اور جوابات)',
          route: '/sawal'),
      GridItem(
          icon: FlutterIslamicIcons.islam,
          label: 'Masails(مسایل)',
          route: '/masail'),
      GridItem(
          icon: Icons.notifications, label: 'Namaaz(نماز)', route: '/namaaz'),
      GridItem(
          icon: FlutterIslamicIcons.solidPrayer,
          label: 'Dua(دعا)',
          route: '/help'),
      GridItem(
          icon: FlutterIslamicIcons.solidTasbih3,
          label: 'Tasbih(تسبیح)',
          route: '/tasbih'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("PANJATAN"),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSawalScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        decoration: myScreenBG(),
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
