import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String level = 'All';
  late Future<List<QuizQuestion>> questions;
  int index = 0, score = 0;
  String? selected;
  bool finished = false;

  @override
  void initState() { super.initState(); questions = _load(); }
  Future<List<QuizQuestion>> _load() => context.read<LearningRepositoryProvider>().repository.getQuiz(level: level);
  void _changeLevel(String v) => setState(() { level = v; index = 0; score = 0; selected = null; finished = false; questions = _load(); });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('অনুশীলন পরীক্ষা')),
    body: FutureBuilder<List<QuizQuestion>>(future: questions, builder: (context, snapshot) {
      if (snapshot.hasError) return const Center(child: Text('প্রশ্ন লোড করা যায়নি। আবার চেষ্টা করুন।'));
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final list = snapshot.data!;
      return Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Wrap(spacing: 8, children: ['All','A1','A2','B1','B2'].map((v) => ChoiceChip(label: Text(v == 'All' ? 'সব' : v), selected: level == v, onSelected: (_) => _changeLevel(v))).toList())),
        if (list.isEmpty) const Expanded(child: Center(child: Text('এই স্তরে প্রশ্ন নেই.')))
        else if (finished) Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.emoji_events, size: 64, color: Color(0xFF176B5B)),
          Text('আপনার স্কোর: $score / ${list.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => setState(() { index = 0; score = 0; selected = null; finished = false; }), child: const Text('আবার চেষ্টা করুন')),
        ])))
        else Expanded(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('প্রশ্ন ${index + 1} / ${list.length}  •  ${list[index].level}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),
          Text(list[index].question, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...list[index].options.map((option) => Padding(padding: const EdgeInsets.only(bottom: 10), child: OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: selected == option ? const Color(0xFFE5F2EE) : Colors.white, padding: const EdgeInsets.all(14), alignment: Alignment.centerLeft),
            onPressed: selected == null ? () => setState(() { selected = option; final correct = option == list[index].answer; if (correct) score++; context.read<LearningRepositoryProvider>().repository.recordProgress(itemType: 'quiz', itemId: list[index].id, correct: correct); }) : null,
            child: Text(option),
          ))),
          if (selected != null) ...[
            const SizedBox(height: 8),
            Text(selected == list[index].answer ? 'সঠিক উত্তর! ' + list[index].explanation : 'সঠিক উত্তর: ${list[index].answer}. ' + list[index].explanation, style: const TextStyle(height: 1.5)),
            const Spacer(),
            FilledButton(onPressed: () => setState(() { if (index + 1 == list.length) { finished = true; } else { index++; selected = null; } }), child: Text(index + 1 == list.length ? 'ফলাফল দেখুন' : 'পরের প্রশ্ন')),
          ] else const Spacer(),
        ]))),
      ]);
    }),
  );
}
