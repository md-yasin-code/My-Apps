import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _aboutUrl = 'https://doetsch-bangla/about.web.app';
  static const _privacyUrl = 'https://doetsch-bangla/privacy-pilicy.web.app';
  static const _developerUrl = 'https://nextit-bd.web.app';
  static const _termsUrl = 'https://deutsch-bangla/terms_conditions.web.app';

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('লিংকটি খোলা যাচ্ছে না। পরে আবার চেষ্টা করুন।')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('অ্যাপ সম্পর্কে')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        Icon(Icons.auto_stories_rounded,
            size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 14),
        Text('Deutsch Bangla',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                )),
        const SizedBox(height: 6),
        const Text('বাংলাভাষীদের জন্য জার্মান শেখার সহায়ক',
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        const Card(
          child: Column(children: [
            ListTile(title: Text('সংস্করণ'), subtitle: Text('1.0.0')),
            Divider(height: 1),
            ListTile(title: Text('শেখার স্তর'), subtitle: Text('CEFR A1 – B2')),
            Divider(height: 1),
            ListTile(title: Text('ডেভেলপার'), subtitle: Text('NEXTIT-BD')),
          ]),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('অফিশিয়াল ওয়েবসাইট'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(context, _aboutUrl),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(context, _privacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(context, _termsUrl),
            ),
            ListTile(
              leading: const Icon(Icons.code_rounded),
              title: const Text('NEXTIT-BD'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(context, _developerUrl),
            ),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: Text(
            'Deutsch Bangla একটি স্বাধীন শিক্ষাসহায়ক অ্যাপ। এটি Goethe-Institut বা অন্য কোনো পরীক্ষাকারী প্রতিষ্ঠানের সঙ্গে অনুমোদিত/অধিভুক্ত নয়। অ্যাপের বাংলা উচ্চারণ আনুমানিক নির্দেশনা।',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.55),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
