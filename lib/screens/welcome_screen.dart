import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:panjatan_app/screens/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Panjatan",
          body: "Explore the app to discover amazing features.",
          image: Center(
              child: Image.asset(
            'asset/welcome/welcome1.png',
            height: 175,
            color: const Color.fromARGB(212, 0, 72, 12),
          )),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16),
          ),
        ),
        PageViewModel(
          title: "Stay Organized",
          body: "Manage your tasks and schedule efficiently.",
          image: Center(
              child: Image.asset('asset/welcome/welcome2.jpeg', height: 175)),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16),
          ),
        ),
        PageViewModel(
          title: "Get Started",
          body: "Let’s begin your journey with Panjatan.",
          image: Center(
              child: Image.asset('asset/welcome/welcome3.png', height: 175)),
          footer: ElevatedButton(
            onPressed: () {
              // Navigate to the next page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text("Start Now"),
          ),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16),
          ),
        ),
      ],
      onDone: () {
        // Navigate to home when done button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      onSkip: () {
        // Navigate to home when skip button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10, 10),
        color: Colors.grey,
        activeSize: Size(22, 10),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
