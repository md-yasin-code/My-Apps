import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../presentation/controllers/app_controller.dart';
import '../services/speech_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('সেটিংস')),
    body: Consumer<AppController>(builder: (context, app, _) => ListView(padding: const EdgeInsets.all(16), children: [
      const Text('দেখতে কেমন হবে', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Card(child: Column(children: [
        RadioListTile<ThemeMode>(title: const Text('সিস্টেমের সঙ্গে'), value: ThemeMode.system, groupValue: app.themeMode, onChanged: (v) { if (v != null) app.setTheme(v); }),
        RadioListTile<ThemeMode>(title: const Text('লাইট মোড'), value: ThemeMode.light, groupValue: app.themeMode, onChanged: (v) { if (v != null) app.setTheme(v); }),
        RadioListTile<ThemeMode>(title: const Text('ডার্ক মোড'), value: ThemeMode.dark, groupValue: app.themeMode, onChanged: (v) { if (v != null) app.setTheme(v); }),
      ])),
      const SizedBox(height: 18),
      const Text('জার্মান উচ্চারণ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      Card(child: ListTile(
        leading: const Icon(Icons.record_voice_over_rounded),
        title: const Text('ভয়েস পরীক্ষা করুন'),
        subtitle: const Text('ফোনে German (de-DE) voice data ইনস্টল থাকতে হবে'),
        trailing: const Icon(Icons.volume_up_rounded),
        onTap: () async {
          try {
            await SpeechService.instance.speakGerman('Guten Tag! Ich lerne Deutsch.');
          } catch (_) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('German voice পাওয়া যায়নি। Android Text-to-Speech সেটিংসে German voice data ইনস্টল করুন।')));
          }
        },
      )),
      const SizedBox(height: 18),
      const Text('প্রতিদিনের লক্ষ্য', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('প্রতিদিন ${app.dailyGoal}টি শব্দ অনুশীলন', style: const TextStyle(fontWeight: FontWeight.w600)),
        Slider(min: 5, max: 50, divisions: 9, value: app.dailyGoal.toDouble(), label: '${app.dailyGoal}', onChanged: (v) => app.setDailyGoal(v.round())),
      ]))),
      const SizedBox(height: 18),
      const Text('ডেটা ব্যবস্থাপনা', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      Card(child: ListTile(leading: const Icon(Icons.restart_alt), title: const Text('শেখার অগ্রগতি মুছুন'), subtitle: const Text('শব্দ, কুইজ ও দৈনিক অনুশীলনের হিসাব রিসেট হবে'), onTap: () async {
        final yes = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('অগ্রগতি মুছবেন?'), content: const Text('এই কাজটি ফিরিয়ে আনা যাবে না। আপনার শেখার হিসাব মুছে যাবে।'), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('বাতিল')), FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('মুছে ফেলুন'))]));
        if (yes == true && context.mounted) { await context.read<LearningRepositoryProvider>().repository.resetProgress(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('শেখার অগ্রগতি রিসেট হয়েছে।'))); }
      })),
      const SizedBox(height: 18),
      const Text('Deutsch Bangla', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('অ্যাপ পরিচিতি'), subtitle: Text('বাংলাভাষীদের জন্য অফলাইন জার্মান শেখার সহায়ক • A1–B2'))),
      const Padding(padding: EdgeInsets.all(8), child: Text('এটি একটি স্বাধীন শিক্ষাসহায়ক অ্যাপ। Goethe-Institut-এর সঙ্গে এর কোনো আনুষ্ঠানিক সম্পর্ক নেই।', style: TextStyle(color: Colors.grey))),
    ])),
  );
}