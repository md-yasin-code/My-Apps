import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/vocabulary_word.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override State<ReviewScreen> createState() => _ReviewScreenState();
}
class _ReviewScreenState extends State<ReviewScreen> {
  late Future<List<VocabularyWord>> due;
  int index = 0; bool revealed = false;
  @override void initState() { super.initState(); due = _load(); }
  Future<List<VocabularyWord>> _load() => context.read<LearningRepositoryProvider>().repository.getDueWords();
  Future<void> _answer(bool remembered, List<VocabularyWord> words) async {
    final word = words[index];
    await context.read<LearningRepositoryProvider>().repository.recordProgress(itemType: 'word', itemId: word.id, correct: remembered);
    if (!mounted) return;
    setState(() { index++; revealed = false; });
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('আজকের পুনরাবৃত্তি')), body: FutureBuilder<List<VocabularyWord>>(future: due, builder: (context, snapshot) {
    if (snapshot.hasError) return const Center(child: Text('রিভিউ লোড করা যায়নি।'));
    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
    final words = snapshot.data!;
    if (words.isEmpty || index >= words.length) return Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.task_alt, size: 68), const SizedBox(height: 16), const Text('আজকের রিভিউ শেষ!', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('দারুণ কাজ। নিয়মিত অনুশীলন চালিয়ে যান।'), const SizedBox(height: 18), FilledButton(onPressed: () => setState(() { index = 0; due = _load(); }), child: const Text('আবার দেখুন'))])));
    final word = words[index];
    return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('কার্ড ${index + 1} / ${words.length}', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
      const SizedBox(height: 18),
      Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Chip(label: Text(word.level)),
        Text('${word.article == 'der' || word.article == 'die' || word.article == 'das' ? '${word.article} ' : ''}${word.german}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (revealed) ...[Text(word.meaningBn, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600)), Text('উচ্চারণ: ${word.pronunciation}'), const SizedBox(height: 14), Text(word.exampleDe, textAlign: TextAlign.center), Text(word.exampleBn, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))] else const Text('শব্দটির বাংলা অর্থ মনে করার চেষ্টা করুন।'),
      ])))),
      if (!revealed) FilledButton(onPressed: () => setState(() => revealed = true), child: const Text('উত্তর দেখুন')) else Row(children: [Expanded(child: OutlinedButton(onPressed: () => _answer(false, words), child: const Text('আবার শিখব'))), const SizedBox(width: 12), Expanded(child: FilledButton(onPressed: () => _answer(true, words), child: const Text('মনে আছে')))]),
    ]));
  }));
}