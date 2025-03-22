import 'package:flutter/material.dart';

class LockButton extends StatelessWidget {
  final bool isLocked;
  final Animation<double> lockAnimation;
  final VoidCallback onTap;

  const LockButton({
    super.key,
    required this.isLocked,
    required this.lockAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: lockAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (lockAnimation.value * 0.1),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isLocked
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withAlpha(51),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(51),
                  width: 2,
                ),
              ),
              child: Icon(
                isLocked ? Icons.lock : Icons.lock_open,
                size: 64,
                color: isLocked
                    ? Colors.white
                    : Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
        },
      ),
    );
  }
}
