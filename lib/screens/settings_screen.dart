import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
    required this.themeMode,
    required this.onThemeChanged,
  }) : super(key: key);

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _selectedMode;

  @override
  void initState() {
    _selectedMode = widget.themeMode;
    super.initState();
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: 'support@openleaves.app'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email copied to clipboard')),
    );
  }

  void _setTheme(ThemeMode mode) {
    setState(() => _selectedMode = mode);
    widget.onThemeChanged(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & About'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading:
                Icon(Icons.library_music_rounded, color: Color(0xFF0F766E)),
            title: Text(
              "Offline hymnal",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
                "All hymns ship with the app so you can sing anywhere without data."),
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              "Theme",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: _selectedMode,
            onChanged: (mode) => _setTheme(mode ?? ThemeMode.system),
            title: const Text("System"),
            subtitle: const Text("Follow your device setting."),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: _selectedMode,
            onChanged: (mode) => _setTheme(mode ?? ThemeMode.light),
            title: const Text("Light"),
            subtitle: const Text("Bright background for daytime."),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: _selectedMode,
            onChanged: (mode) => _setTheme(mode ?? ThemeMode.dark),
            title: const Text("Dark"),
            subtitle: const Text("Low-glare palette for night."),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text(
              "Version",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text("F.E.A.C. Hymns 1.0.5"),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text(
              "Report an issue / request a hymn",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text("support@openleaves.app"),
            onTap: () => _copyEmail(context),
          ),
        ],
      ),
    );
  }
}
