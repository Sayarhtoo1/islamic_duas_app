import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<Offset> _titleSlideAnimation;
  late final Animation<double> _subtitleFadeAnimation;

  @override
  void initState() {
    super.initState();

    // The main controller for all animations on this screen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), // Total duration for all animations
    );

    // Animation for the logo (fades and scales in during the first 40% of the timeline)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Animation for the main title (slides up and fades in between 30% and 70% of the timeline)
    _titleSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Animation for the subtitles (fades in during the last 40% of the timeline)
    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start all animations
    _controller.forward();

    // Navigate to the home screen after a longer delay (5 seconds)
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // A deep, radial gradient for a more premium background
        color: Colors.white, // Solid white background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Animated Logo ---
              FadeTransition(
                opacity: _logoFadeAnimation,
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Image.asset(
                    'assets/images/Logo.png', // Use the new logo image
                    width: 300, // Adjust size as needed
                    height: 300, // Adjust size as needed
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Animated Title ---
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: SlideTransition(
                  position: _titleSlideAnimation,
                  child: FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Text(
                      'ကျင့်စဉ်မွန်များ',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.black87, // Dark text for white background
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const Shadow(
                                blurRadius: 5.0,
                                color: Colors.black12,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- Animated Subtitles ---
              FadeTransition(
                opacity: _subtitleFadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'စုဆောင်းတင်ပြသူ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black54, // Darker grey for subtitle
                            fontWeight: FontWeight.w300,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'မော်လဝီ မုဟမ္မဒ် ယဟ်ယား (ဆိုလိုင်မာနီ)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black87, // Dark text for white background
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
