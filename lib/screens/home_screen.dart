import 'package:flutter/material.dart';
import 'vocabulary_screen.dart';
import 'lessons_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _HomeTile(icon: Icons.menu_book_rounded, title: 'শব্দভান্ডার', subtitle: 'অর্থ, উচ্চারণ ও উদাহরণ', page: const VocabularyScreen()),
      _HomeTile(icon: Icons.school_rounded, title: 'গ্রামার ও লেসন', subtitle: 'সহজ বাংলায় নিয়ম শিখুন', page: const LessonsScreen()),
      _HomeTile(icon: Icons.quiz_rounded, title: 'অনুশীলন পরীক্ষা', subtitle: 'নিজের দক্ষতা যাচাই করুন', page: const QuizScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Deutsch Bangla', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF145C50), Color(0xFF258B72)]), borderRadius: BorderRadius.circular(24)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('জার্মান শেখা, বাংলায়', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('A1 থেকে B2 • সম্পূর্ণ অফলাইন', style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 18),
            Text('শুরু করুন ছোট ছোট ধাপে। প্রতিদিন শিখুন, অনুশীলন করুন।', style: TextStyle(color: Colors.white, height: 1.5)),
          ]),
        ),
        const SizedBox(height: 22),
        const Text('আপনার শেখার বিভাগ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...tiles.map((t) => Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: CircleAvatar(backgroundColor: const Color(0xFFE5F2EE), child: Icon(t.icon, color: const Color(0xFF176B5B))),
            title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(t.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => t.page)),
          ),
        )),
        const SizedBox(height: 12),
        const Text('শেখার স্তর', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Wrap(spacing: 8, children: [
          Chip(label: Text('A1 Beginner')), Chip(label: Text('A2 Elementary')),
          Chip(label: Text('B1 Intermediate')), Chip(label: Text('B2 Upper-Intermediate')),
        ]),
        const SizedBox(height: 12),
        const Text('টিপস: noun সবসময় article ও plural-সহ শিখুন। প্রতিটি শব্দ দিয়ে নিজের একটি বাক্য তৈরি করুন.', style: TextStyle(color: Colors.black54, height: 1.5)),
      ]),
    );
  }
}

class _HomeTile {
  const _HomeTile({required this.icon, required this.title, required this.subtitle, required this.page});
  final IconData icon;
  final String title, subtitle;
  final Widget page;
}
