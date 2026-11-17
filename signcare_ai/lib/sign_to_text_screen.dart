import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'l10n_ext.dart';

/// "Sign to Text" abhi under construction hai.
/// Chhote builder bots kaam karte dikhate hain (hammer, ladder, welding,
/// eenten). Sab kuch code se bana hai, koi image/asset nahi.
class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  State<SignToTextScreen> createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Jin ke phone mein "animations band" hain, unke liye animation ruki rahe.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.3;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.menuSignTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: _Scene.width / _Scene.height,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _Scene.width,
                    height: _Scene.height,
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) =>
                          _Scene(t: _controller.value, colors: colors),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.signSoonTitle,
                  style: context.text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              l10n.signSoonBody,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: colors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.signSoonNote,
                        style: context.text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tasveer ke rang (hard hat, lakri, eenten waghera) dono themes mein ek jaise.
const Color _hatColor = Color(0xFFFFC107);
const Color _hatBrim = Color(0xFFFFA000);
const Color _woodColor = Color(0xFF8D6E63);
const Color _brickColor = Color(0xFFD84315);
const Color _metalColor = Color(0xFF546E7A);
const Color _visorColor = Color(0xFF263238);
const Color _sparkColor = Color(0xFFFFB300);

/// Poora manzar. t: 0..1 (4 second ka ek chakkar).
class _Scene extends StatelessWidget {
  const _Scene({required this.t, required this.colors});

  static const double width = 340;
  static const double height = 290;
  static const double _ground = 280; // zameen ki uper ki line
  static const double _botH = _Bot.height;

  final double t;
  final ColorScheme colors;

  double _wave(double times, [double phase = 0]) =>
      math.sin(2 * math.pi * (t * times + phase));

  double _frac(double v) => v - v.floorToDouble();

  @override
  Widget build(BuildContext context) {
    final eye = colors.onPrimaryContainer;
    final headColor = colors.primaryContainer;

    // ---- Bot D: scaffold par eent uthata hai ----
    final lift = 0.5 + 0.5 * _wave(1);
    final brickTop = 52 - 62 * lift;

    // ---- Bot B: seerhi lekar chalta hai ----
    final walkX = 12 * _wave(1);
    final facing = math.cos(2 * math.pi * t) >= 0 ? 1.0 : -1.0;

    // ---- Bot A: hathora maarta hai ----
    final swing = _wave(3);
    final hammerAngle = -1.57 - 0.93 * (0.5 + 0.5 * swing);
    final hit = ((-swing - 0.7) / 0.3).clamp(0.0, 1.0);

    // ---- Structure ka progress ----
    final progress = 0.15 + 0.7 * (0.5 + 0.5 * _wave(1, 0.25));

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // zameen
        Positioned(
          left: 0,
          right: 0,
          top: _ground,
          height: height - _ground,
          child: ColoredBox(color: colors.outlineVariant),
        ),

        // bayen taraf ka scaffold
        const Positioned(left: 6, top: 128, width: 6, height: _ground - 128,
            child: ColoredBox(color: _woodColor)),
        const Positioned(left: 92, top: 128, width: 6, height: _ground - 128,
            child: ColoredBox(color: _woodColor)),
        const Positioned(left: 0, top: 120, width: 104, height: 8,
            child: ColoredBox(color: _woodColor)),

        // dayen taraf ka latakta hua platform (rassiyan upar se)
        const Positioned(left: 252, top: 0, width: 2, height: 120,
            child: ColoredBox(color: _metalColor)),
        const Positioned(left: 330, top: 0, width: 2, height: 120,
            child: ColoredBox(color: _metalColor)),
        const Positioned(left: 244, top: 120, width: 96, height: 8,
            child: ColoredBox(color: _woodColor)),

        // beech ki imarat: camera + haath (jo bana rahe hain)
        Positioned(
          left: 110,
          top: 22,
          width: 120,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.primary, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_outlined, size: 44, color: colors.primary),
                const SizedBox(height: 4),
                Icon(
                  Icons.pan_tool_alt_outlined,
                  size: 36,
                  color: colors.primary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // lakri ka takhta (hathora yahan lagta hai) aur welding ki patti
        const Positioned(left: 182, top: 226, width: 10, height: 54,
            child: ColoredBox(color: _woodColor)),
        const Positioned(left: 198, top: 244, width: 38, height: 10,
            child: ColoredBox(color: _metalColor)),

        // Bot D (scaffold par) + eent
        Positioned(
          left: 28,
          top: 120 - _botH,
          child: _Bot(
            body: colors.primary,
            head: headColor,
            eye: eye,
            leftArm: 0.3 + 2.0 * lift,
            rightArm: -(0.3 + 2.0 * lift),
          ),
        ),
        Positioned(
          left: 46,
          top: 120 - _botH + brickTop,
          width: 20,
          height: 11,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: _brickColor,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),

        // Bot B (seerhi ke sath)
        Positioned(
          left: 266 + walkX,
          top: 120 - _botH,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(facing, 1, 1),
            child: _Bot(
              body: colors.tertiary,
              head: headColor,
              eye: eye,
              leftArm: 0.9,
              rightArm: -0.9,
              walk: _wave(4),
              extras: const [
                Positioned(left: -8, top: -34, child: _Ladder()),
              ],
            ),
          ),
        ),

        // Bot A (hathora)
        Positioned(
          left: 104,
          top: _ground - _botH,
          child: _Bot(
            body: colors.secondary,
            head: headColor,
            eye: eye,
            leftArm: 0.15,
            rightArm: hammerAngle,
            rightHold: Container(
              width: 16,
              height: 8,
              decoration: const BoxDecoration(
                color: _metalColor,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        ),
        Positioned(
          left: 170,
          top: 226,
          child: Opacity(
            opacity: hit,
            child: const Icon(Icons.flash_on, size: 18, color: _sparkColor),
          ),
        ),

        // Bot C (welding, ulta ghoom kar)
        Positioned(
          left: 238,
          top: _ground - _botH,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(-1, 1, 1),
            child: _Bot(
              body: colors.primary,
              head: headColor,
              eye: eye,
              visor: true,
              leftArm: 0.15,
              rightArm: -1.35,
              rightHold: Container(
                width: 6,
                height: 18,
                decoration: const BoxDecoration(
                  color: _metalColor,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
            ),
          ),
        ),

        // welding ki chingariyan (torch ki nok ke paas)
        ..._sparks(),
      ],
    );
  }

  List<Widget> _sparks() {
    const tipX = 204.5;
    const tipY = 249.0;
    final glow = 10 + 5 * _wave(12);
    final result = <Widget>[
      Positioned(
        left: tipX - glow / 2,
        top: tipY - glow / 2,
        width: glow,
        height: glow,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _sparkColor.withValues(alpha: 0.85),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
    for (var i = 0; i < 6; i++) {
      final phase = _frac(t * 6 + i / 6);
      final angle = i * 1.1;
      final radius = 4 + 14 * phase;
      final dx = math.cos(angle) * radius;
      final dy = -math.sin(angle).abs() * radius * 1.1 + phase * phase * 12;
      result.add(
        Positioned(
          left: tipX + dx - 2,
          top: tipY + dy - 2,
          width: 4,
          height: 4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _sparkColor.withValues(alpha: 1 - phase),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    return result;
  }
}

/// Chhota builder robot. Haath ghoomte hain (angle radians mein).
/// Positive angle: haath bayen taraf; negative: dayen taraf.
class _Bot extends StatelessWidget {
  const _Bot({
    required this.body,
    required this.head,
    required this.eye,
    this.leftArm = 0.1,
    this.rightArm = -0.1,
    this.leftHold,
    this.rightHold,
    this.walk = 0,
    this.visor = false,
    this.extras = const [],
  });

  static const double width = 56;
  static const double height = 82;

  final Color body;
  final Color head;
  final Color eye;
  final double leftArm;
  final double rightArm;
  final Widget? leftHold;
  final Widget? rightHold;
  final double walk; // -1..1, taangon ki halchal
  final bool visor;
  final List<Widget> extras;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // taangein
          Positioned(
            left: 17,
            top: 64,
            width: 9,
            height: 14 + 3 * walk,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: body,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 64,
            width: 9,
            height: 14 - 3 * walk,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: body,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // jism
          Positioned(
            left: 12,
            top: 38,
            width: 32,
            height: 26,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: body,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // sar
          Positioned(
            left: 14,
            top: 14,
            width: 28,
            height: 22,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: head,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
          // aankhein
          Positioned(left: 19, top: 22, width: 6, height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(color: eye, shape: BoxShape.circle),
              )),
          Positioned(left: 31, top: 22, width: 6, height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(color: eye, shape: BoxShape.circle),
              )),
          // welding ka mask
          if (visor)
            const Positioned(
              left: 14,
              top: 19,
              width: 28,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _visorColor,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          // hard hat
          const Positioned(
            left: 13,
            top: 2,
            width: 30,
            height: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _hatColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
          ),
          const Positioned(
            left: 10,
            top: 12,
            width: 36,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _hatBrim,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
          // haath
          Positioned(
            left: 4,
            top: 42,
            child: _Arm(angle: leftArm, color: body, hold: leftHold),
          ),
          Positioned(
            left: 45,
            top: 42,
            child: _Arm(angle: rightArm, color: body, hold: rightHold),
          ),
          ...extras,
        ],
      ),
    );
  }
}

/// Kandhe ke upar se ghoomta hua haath. Aakhir mein koi cheez (hold) pakad sakta hai.
class _Arm extends StatelessWidget {
  const _Arm({required this.angle, required this.color, this.hold});

  final double angle;
  final Color color;
  final Widget? hold;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 7,
      height: 24,
      child: OverflowBox(
        maxWidth: 40,
        maxHeight: 70,
        alignment: Alignment.topCenter,
        child: Transform.rotate(
          angle: angle,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              ?hold,
            ],
          ),
        ),
      ),
    );
  }
}

class _Ladder extends StatelessWidget {
  const _Ladder();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.35,
      child: SizedBox(
        width: 22,
        height: 80,
        child: Stack(
          children: [
            const Positioned(left: 0, top: 0, bottom: 0, width: 4,
                child: ColoredBox(color: _woodColor)),
            const Positioned(right: 0, top: 0, bottom: 0, width: 4,
                child: ColoredBox(color: _woodColor)),
            for (var i = 0; i < 5; i++)
              Positioned(
                left: 3,
                right: 3,
                top: 8.0 + i * 16,
                height: 3,
                child: const ColoredBox(color: _woodColor),
              ),
          ],
        ),
      ),
    );
  }
}
