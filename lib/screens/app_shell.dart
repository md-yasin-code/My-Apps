import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';
import 'about_screen.dart';
import 'auth_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'lessons_screen.dart';
import 'progress_screen.dart';
import 'quiz_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';
import 'vocabulary_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.database});
  final AppDatabase database;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  late final CloudSyncService _sync = CloudSyncService(widget.database);

  static const _titles = ['হোম', 'শব্দভান্ডার', 'লেসন', 'অগ্রগতি'];
  late final List<Widget> _tabs = const [
    HomeScreen(),
    VocabularyScreen(),
    LessonsScreen(),
    ProgressScreen(),
  ];

  Future<void> _openAuth() async {
    try {
      await Navigator.push(context, MaterialPageRoute(
        builder: (_) => AuthScreen(syncService: _sync),
      ));
      if (mounted) setState(() {});
    } on FirebaseException catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase কনফিগারেশন সম্পূর্ণ হয়নি। সেটআপ নির্দেশনা দেখুন।')),
      );
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase এখনো প্রস্তুত নয়।')),
      );
    }
  }

  Future<void> _syncNow() async {
    try {
      await _sync.syncNow();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('আপনার শেখার অগ্রগতি ক্লাউডে সেভ হয়েছে।')),
      );
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সিঙ্ক করা যায়নি। লগইন ও ইন্টারনেট সংযোগ পরীক্ষা করুন।')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instanceOrNull?.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index], style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          if (user != null)
            IconButton(tooltip: 'ক্লাউডে সিঙ্ক করুন', onPressed: _syncNow, icon: const Icon(Icons.cloud_upload_outlined)),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: user?.email ?? 'অ্যাকাউন্ট',
              onPressed: _openAuth,
              icon: Icon(user == null ? Icons.account_circle_outlined : Icons.account_circle),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(user),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 360),
        reverseDuration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.025, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(key: ValueKey(_index), child: _tabs[_index]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'হোম'),
          NavigationDestination(icon: Icon(Icons.translate_rounded), label: 'শব্দ'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'লেসন'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'অগ্রগতি'),
        ],
      ),
    );
  }

  Widget _buildDrawer(User? user) => NavigationDrawer(
    selectedIndex: null,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(radius: 25, child: Icon(Icons.auto_stories_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer)),
          const SizedBox(height: 12),
          const Text('Deutsch Bangla', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const Text('জার্মান শিখুন, বাংলায়'),
          const SizedBox(height: 8),
          Text(user?.email ?? 'Guest mode • অফলাইন শেখা'),
        ]),
      ),
      const Divider(),
      NavigationDrawerDestination(icon: const Icon(Icons.quiz_outlined), label: const Text('কুইজ ও অনুশীলন')),
      NavigationDrawerDestination(icon: const Icon(Icons.replay_circle_filled_outlined), label: const Text('রিভিউ / পুনরাবৃত্তি')),
      NavigationDrawerDestination(icon: const Icon(Icons.favorite_border), label: const Text('পছন্দের তালিকা')),
      const Padding(padding: EdgeInsets.fromLTRB(28, 18, 16, 8), child: Text('অ্যাকাউন্ট ও অ্যাপ')),
      NavigationDrawerDestination(icon: const Icon(Icons.cloud_sync_outlined), label: const Text('লগইন / ক্লাউড সিঙ্ক')),
      NavigationDrawerDestination(icon: const Icon(Icons.settings_outlined), label: const Text('সেটিংস')),
      NavigationDrawerDestination(icon: const Icon(Icons.info_outline), label: const Text('অ্যাপ সম্পর্কে')),
      if (user != null)
        NavigationDrawerDestination(icon: const Icon(Icons.logout), label: const Text('লগআউট')),
    ],
    onDestinationSelected: (value) {
      Navigator.pop(context);
      switch (value) {
        case 0: Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())); break;
        case 1: Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewScreen())); break;
        case 2: Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())); break;
        case 3: _openAuth(); break;
        case 4: Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); break;
        case 5: Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())); break;
        case 6: AuthService.instance.signOut().then((_) { if (mounted) setState(() {}); }); break;
      }
    },
  );
}
