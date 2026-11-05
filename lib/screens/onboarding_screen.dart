import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/controllers/app_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Spacer(),
    Center(child: Container(width: 112, height: 112, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(32)), child: Icon(Icons.translate_rounded, size: 58, color: Theme.of(context).colorScheme.primary))),
    const SizedBox(height: 34),
    const Text('স্বাগতম Deutsch Bangla-তে', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    const Text('বাংলায় ব্যাখ্যা, জার্মান শব্দভান্ডার এবং অনুশীলনের মাধ্যমে A1 থেকে B2 পর্যন্ত শেখার যাত্রা শুরু করুন।', style: TextStyle(fontSize: 16, height: 1.6)),
    const SizedBox(height: 24),
    const _Feature(icon: Icons.wifi_off, title: 'সম্পূর্ণ অফলাইন', detail: 'ইন্টারনেট ছাড়াই সংরক্ষিত পাঠ ও শব্দ শিখুন।'),
    const _Feature(icon: Icons.menu_book, title: 'শব্দ ও ব্যাকরণ', detail: 'বাংলা অর্থ, উচ্চারণ, উদাহরণ ও grammar lesson।'),
    const _Feature(icon: Icons.quiz, title: 'অনুশীলন ও অগ্রগতি', detail: 'কুইজ দিন এবং নিজের শেখার হিসাব রাখুন।'),
    const Spacer(),
    SizedBox(width: double.infinity, child: FilledButton(onPressed: () => context.read<AppController>().finishOnboarding(), child: const Padding(padding: EdgeInsets.all(14), child: Text('শেখা শুরু করি')))),
    const SizedBox(height: 12),
    const Center(child: Text('স্বাধীন শিক্ষাসহায়ক অ্যাপ • Goethe-Institut-এর অফিসিয়াল অ্যাপ নয়', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey))),
  ]))));
}
class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.title, required this.detail});
  final IconData icon; final String title, detail;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(detail, style: const TextStyle(color: Colors.grey, height: 1.4))]))]));
}