import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  static void show(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ThemeSettingsPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: [
          RadioListTile<ThemeMode>(
            title: Text(
              'System Default',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            value: ThemeMode.system,
            // ignore: deprecated_member_use
            groupValue: currentTheme,
            activeColor: theme.colorScheme.primary,
            // ignore: deprecated_member_use
            onChanged: (val) =>
                ref.read(themeModeProvider.notifier).setThemeMode(val!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(
              'Light',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            value: ThemeMode.light,
            // ignore: deprecated_member_use
            groupValue: currentTheme,
            activeColor: theme.colorScheme.primary,
            // ignore: deprecated_member_use
            onChanged: (val) =>
                ref.read(themeModeProvider.notifier).setThemeMode(val!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(
              'Dark',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            value: ThemeMode.dark,
            // ignore: deprecated_member_use
            groupValue: currentTheme,
            activeColor: theme.colorScheme.primary,
            // ignore: deprecated_member_use
            onChanged: (val) =>
                ref.read(themeModeProvider.notifier).setThemeMode(val!),
          ),
        ],
      ),
    );
  }
}
