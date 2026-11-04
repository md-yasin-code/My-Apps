import 'package:flutter/material.dart';
import 'vocabulary_screen.dart';
import 'lessons_screen.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) {
    final tiles = [
      _HomeTile(Icons.menu_book_rounded, 'শব্দভান্ডার', 'অর্থ, উচ্চারণ, উদাহরণ ও পছন্দের শব্দ', const VocabularyScreen()),
      _HomeTile(Icons.school_rounded, 'গ্রামার ও লেসন', 'A1 থেকে B2 পর্যন্ত সহজ বাংলা ব্যাখ্যা', const LessonsScreen()),
      _HomeTile(Icons.quiz_rounded, 'অনুশীলন পরীক্ষা', 'শব্দভান্ডার ও ব্যাকরণ যাচাই করুন', const QuizScreen()),
      _HomeTile(Icons.insights_rounded, 'আমার অগ্রগতি', 'আপনার শেখার পরিসংখ্যান দেখুন', const ProgressScreen()),
      _HomeTile(Icons.settings_rounded, 'সেটিংস', 'থিম, দৈনিক লক্ষ্য ও ডেটা ব্যবস্থাপনা', const SettingsScreen()),
    ];
    return Scaffold(appBar: AppBar(title: const Text('Deutsch Bangla', style: TextStyle(fontWeight: FontWeight.w800))), body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF145C50), Color(0xFF258B72)]), borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('জার্মান শেখা, বাংলায়', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
        SizedBox(height: 8), Text('A1 থেকে B2 • অফলাইন লার্নিং', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 18), Text('প্রতিদিন অল্প অল্প শিখুন। শব্দ মনে রাখুন, ব্যাকরণ বুঝুন এবং অনুশীলন করুন।', style: TextStyle(color: Colors.white, height: 1.5)),
      ])),
      const SizedBox(height: 22), const Text('আপনার শেখার বিভাগ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      ...tiles.map((t) => Card(child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9), leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondaryContainer, child: Icon(t.icon)), title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(t.subtitle), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => t.page))))),
      const SizedBox(height: 12), const Text('শেখার স্তর', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), const Wrap(spacing: 8, children: [Chip(label: Text('A1 Beginner')), Chip(label: Text('A2 Elementary')), Chip(label: Text('B1 Intermediate')), Chip(label: Text('B2 Upper-Intermediate'))]),
      const SizedBox(height: 12), const Text('টিপস: জার্মান noun সবসময় article ও plural-সহ শিখুন। প্রতিটি শব্দ দিয়ে নিজের বাক্য তৈরি করুন।', style: TextStyle(color: Colors.grey, height: 1.5)),
    ]));
  }
}
class _HomeTile {
  const _HomeTile(this.icon, this.title, this.subtitle, this.page);
  final IconData icon; final String title, subtitle; final Widget page;
}