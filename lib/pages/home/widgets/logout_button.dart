import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_event.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        foregroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.error,
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Confirm Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Do you really want to logout?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
