import 'package:flutter/material.dart';

class ScheduleMealModal extends StatelessWidget {
  const ScheduleMealModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Center(
        child: Text(
          "Coming soon!",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
