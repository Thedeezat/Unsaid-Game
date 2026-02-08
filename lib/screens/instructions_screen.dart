import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  late PageController _pageController;

  static const List<_InstructionPage> _pages = [
    _InstructionPage(
      title: 'Civilians',
      body: 'They all receive the same secret word. Work together during the discussion to spot who is describing something different. Their goal is to unmask the Undercover before it\'s too late.',
      imagePath: 'assets/girl.jpg',
      icon: Icons.people_rounded,
      iconColor: AppTheme.citizenColor,
    ),
    _InstructionPage(
      title: 'Undercover',
      body: 'They receive a word slightly different from the Civilians. Blend in by giving clues that could fit both words. Their goal is to pretend to be a Civilian and survive the votes!',
      imagePath: 'assets/gangster.jpg',
      icon: Icons.visibility_off_rounded,
      iconColor: AppTheme.undercoverColor,
    ),
    _InstructionPage(
      title: 'Get your word',
      body: 'Pass the phone around so each player can see their secret word in private. Right now, you don\'t know if you are a Civilian or an Undercover—keep it to yourself!',
      imagePath: 'assets/words.jpg',
      icon: Icons.phone_android_rounded,
      iconColor: AppTheme.primaryBlue,
    ),
    _InstructionPage(
      title: 'Discussion time',
      body: 'Non-eliminated players take turns describing their word without saying it aloud. Listen carefully, make allies, and try to flush out the Undercover before the vote.',
      imagePath: 'assets/group.jpg',
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: AppTheme.primaryBlue,
    ),
    _InstructionPage(
      title: 'Vote',
      body: 'When it\'s time to vote, choose the player you suspect is the Undercover. The player with the most votes is eliminated. On a tie, no one is eliminated and the game continues.',
      imagePath: 'assets/vote.jpg',
      icon: Icons.how_to_vote_rounded,
      iconColor: AppTheme.accentOrange,
    ),
    _InstructionPage(
      title: 'Winning',
      body: 'Citizens win if they eliminate the Undercover. The Undercover wins when only two players remain (the Undercover and one Citizen). Every round counts!',
      imagePath: 'assets/winning.jpg',
      icon: Icons.emoji_events_rounded,
      iconColor: AppTheme.successGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const Color _instructionsBg = Color(0xFFB2E9FF);
  static const double _instructionsBgOpacity = 0.72;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFF5FBFF),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _instructionsBg.withValues(alpha: _instructionsBgOpacity),
                  const Color(0xFFC5EFFF).withValues(alpha: _instructionsBgOpacity),
                  const Color(0xFFD8F4FF).withValues(alpha: _instructionsBgOpacity),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _InstructionsBgPatternPainter(),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.18),
                        Colors.white.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Stack(
          children: [
            SafeArea(
              top: false,
              bottom: true,
              left: true,
              right: true,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _InstructionPageView(page: _pages[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24, top: 12),
                    child: _PageIndicator(
                      pageCount: _pages.length,
                      controller: _pageController,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: topPadding + 8,
              right: 8,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close_rounded, color: Color(0xFF555555), size: 22),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }
}

class _InstructionPage {
  const _InstructionPage({
    required this.title,
    required this.body,
    required this.imagePath,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String body;
  final String imagePath;
  final IconData icon;
  final Color iconColor;
}

class _InstructionPageView extends StatelessWidget {
  const _InstructionPageView({required this.page});

  final _InstructionPage page;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxImageHeight = screenHeight * 0.52;
    return Column(
      children: [
        SizedBox(
          height: maxImageHeight,
          width: double.infinity,
          child: Material(
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.15),
            child: Image.asset(
              page.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white.withValues(alpha: 0.8),
                child: Center(
                  child: Icon(
                    page.icon,
                    size: 80,
                    color: page.iconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 0),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.primaryBlueDark,
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    page.body,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.55,
                      color: Colors.white.withValues(alpha: 0.98),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.pageCount,
    required this.controller,
  });

  final int pageCount;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.hasClients ? (controller.page ?? 0.0) : 0.0;
        final current = page.round().clamp(0, pageCount - 1);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (i) => _dot(i == current),
          ),
        );
      },
    );
  }

  Widget _dot(bool active) {
    const activeColor = Color(0xFFB2E9FF);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: active ? 10 : 8,
      height: active ? 10 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? activeColor : const Color(0xFF5C6B73),
        border: active ? Border.all(color: const Color(0xFF90A4AE), width: 1) : null,
        boxShadow: active
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }
}

class _InstructionsBgPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    for (var x = 0.0; x < size.width + spacing; x += spacing) {
      for (var y = 0.0; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
