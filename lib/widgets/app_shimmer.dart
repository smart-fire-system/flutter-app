import 'package:flutter/material.dart';

/// A lightweight shimmer/highlight sweep for any widget.
///
/// Drive it by passing a repeating [progress] value in range [0..1].
class AppShimmer extends StatelessWidget {
  final double progress;
  final Widget child;
  final double opacity;

  const AppShimmer({
    super.key,
    required this.progress,
    required this.child,
    this.opacity = 0.20,
  });

  @override
  Widget build(BuildContext context) {
    // A subtle moving highlight from left → right.
    final x = (progress * 2) - 1; // [-1..1]
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment(-1.0 + x, -1.0),
                    end: Alignment(1.0 + x, 1.0),
                    colors: const [
                      Colors.transparent,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: const [0.45, 0.55, 0.65],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcATop,
                child: Container(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


