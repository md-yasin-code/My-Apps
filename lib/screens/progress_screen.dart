import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../presentation/controllers/app_controller.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override State<ProgressScreen> createState() => _ProgressScreenState();
}
class _ProgressScreenState extends State<ProgressScreen> {
  late Future<Map<String, Object?>> summary;
  @override void initState() { super.initState(); summary = _load(); }
  Future<Map<String, Object?>> _load() => context.read<LearningRepositoryProvider>().repository.getProgressSummary();
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('আমার অগ্রগতি')), body: FutureBuilder<Map<String, Object?>>(
    future: summary, builder: (context, snapshot) {
      if (snapshot.hasError) return const Center(child: Text('অগ্রগতি লোড করা যায়নি।'));
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final data = snapshot.data!;
      final correct = (data['quiz_correct'] as num?)?.toInt() ?? 0;
      final total = (data['quiz_total'] as num?)?.toInt() ?? 0;
      final accuracy = total == 0 ? 0.0 : correct / total;
      final todayWords = (data['today_words'] as num?)?.toInt() ?? 0;
      final goal = context.watch<AppController>().dailyGoal;
      return RefreshIndicator(onRefresh: () async => setState(() => summary = _load()), child: ListView(padding: const EdgeInsets.all(18), children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('কুইজের সঠিক উত্তরের হার'), const SizedBox(height: 12), Text('${(accuracy * 100).round()}%', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)), LinearProgressIndicator(value: accuracy), const SizedBox(height: 8), Text('$correctটি সঠিক / $totalটি উত্তর')]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('আজকের লক্ষ্য: $todayWords / $goal শব্দ', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 10), LinearProgressIndicator(value: (todayWords / goal).clamp(0.0, 1.0)), const SizedBox(height: 6), const Text('প্রতিদিনের ছোট লক্ষ্য পূরণে মনোযোগ দিন।', style: TextStyle(color: Colors.grey))])),
        _stat('বর্তমান ধারাবাহিকতা', '${data['current_streak'] ?? 0} দিন', Icons.local_fire_department),
        _stat('শেখা শব্দ', '${data['words_learned'] ?? 0}', Icons.translate),
        _stat('অনুশীলন করা লেসন', '${data['lessons_touched'] ?? 0}', Icons.menu_book),
        _stat('সক্রিয় দিন', '${data['active_days'] ?? 0}', Icons.calendar_month),
        const SizedBox(height: 12),
        const Text('নিয়মিত অল্প অল্প অনুশীলন করাই ভাষা শেখার সবচেয়ে কার্যকর অভ্যাসগুলোর একটি।', style: TextStyle(color: Colors.grey, height: 1.5)),
      ]));
    },
  ));
  Widget _stat(String label, String value, IconData icon) => Card(child: ListTile(leading: CircleAvatar(child: Icon(icon)), title: Text(label), trailing: Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))));
}