import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../features/bonds_list/presentation/screens/bonds_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _glowController;
  late final AnimationController _exitController;

  late final Animation<double> _scaleIn;
  late final Animation<double> _tilt;
  late final Animation<double> _fadeIn;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Intro timeline
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Gentle glow + float loop
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Exit (zoom-out + fade)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    // Scale with overshoot then settle
    _scaleIn = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.07).chain(CurveTween(curve: Curves.easeOut)), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.07, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.02).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
    ]).animate(_introController);

    // Small tilt that straightens
    _tilt = Tween<double>(begin: -0.04, end: 0.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOut),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeIn),
    );

    _introController.forward();

    // Navigate after short showcase with exit animation
    _timer = Timer(const Duration(milliseconds: 1650), () async {
      if (!mounted) return;
      await _exitController.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(_fadeScaleRoute(const BondsListScreen()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _introController.dispose();
    _glowController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          const _AnimatedBackdrop(),

          // Center logo with float, tilt, scale and exit zoom-out
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_introController, _glowController, _exitController]),
              builder: (_, __) {
                final t = _glowController.value;
                final floatY = math.sin(t * math.pi * 2) * (isTablet ? 6 : 4);
                final exitScale = 1.0 - 0.12 * _exitController.value; // zoom-out on exit
                final exitFade = 1.0 - _exitController.value;

                return Opacity(
                  opacity: _fadeIn.value * exitFade,
                  child: Transform.translate(
                    offset: Offset(0, floatY),
                    child: Transform.rotate(
                      angle: _tilt.value,
                      child: Transform.scale(
                        scale: _scaleIn.value * exitScale,
                        child: _GlowingLogo(
                          size: isTablet ? 190 : 150,
                          animation: _glowController,
                          assetPath: 'assets/images/logo.png',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Title + loader
          Positioned(
            bottom: isTablet ? 64 : 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'TapInc',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2A2A),
                    ),
                  ),
                  SizedBox(height: 10),
                  _DotsLoader(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AnimatedBackdrop extends StatefulWidget {
  const _AnimatedBackdrop();

  @override
  State<_AnimatedBackdrop> createState() => _AnimatedBackdropState();
}

class _AnimatedBackdropState extends State<_AnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value; // 0..1
        final hueShift = (0.5 + 0.5 * math.sin(2 * math.pi * t));
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(const Color(0xFFF6F9FF), const Color(0xFFEFF3FF), hueShift)!,
                Color.lerp(const Color(0xFFF3F6FF), const Color(0xFFE8EEFF), 1 - hueShift)!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GlowingLogo extends StatelessWidget {
  final double size;
  final Animation<double> animation;
  final String assetPath;
  const _GlowingLogo({
    required this.size,
    required this.animation,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = animation.value; // 0..1
        final glow = (math.sin(t * math.pi) * 0.35 + 0.65); // 0.3..1.0
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4661F7).withOpacity(0.25 * glow),
                blurRadius: 24 + 12 * glow,
                spreadRadius: 2 + 2 * glow,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.22),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Icon(Icons.image_not_supported,
                    color: Colors.grey[400], size: size * 0.35),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DotsLoader extends StatefulWidget {
  const _DotsLoader();

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value; // 0..1
        double dot(int i) => 0.3 + 0.7 * (1 - ((t - i / 3).abs() * 3).clamp(0.0, 1.0));
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(opacity: dot(0), child: _dot()),
            const SizedBox(width: 6),
            Opacity(opacity: dot(1), child: _dot()),
            const SizedBox(width: 6),
            Opacity(opacity: dot(2), child: _dot()),
          ],
        );
      },
    );
  }

  Widget _dot() => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: const Color(0xFF4661F7),
          borderRadius: BorderRadius.circular(3),
        ),
      );
}

Route _fadeScaleRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, secondary, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      final scale = Tween<double>(begin: 0.98, end: 1.0).animate(fade);
      final slide = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(fade);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: ScaleTransition(scale: scale, child: child),
        ),
      );
    },
  );
}
