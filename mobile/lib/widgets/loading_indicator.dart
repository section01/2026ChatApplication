import 'dart:math';

import 'package:flutter/material.dart';

/// 点が円を描くように回転するローディング表示
class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {

  // アニメーションを管理するコントローラー
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 1秒で1周するアニメーション
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    // アニメーションを終了する
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(8, (index) {
              // 点を円周上に配置する角度
              final angle =
                  (2 * pi / 8) * index +
                  (_controller.value * 2 * pi);

              // 円の中心からの距離
              const radius = 20.0;

              return Transform.translate(
                offset: Offset(
                  cos(angle) * radius,
                  sin(angle) * radius,
                ),
                child: SizedBox(
                  width: 7,
                  height: 7,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: 0.2 +
                            (0.8 *
                                (1 -
                                    (((_controller.value * 8 - index + 8) % 8) / 8))),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}