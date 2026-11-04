import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/vocabulary_word.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});
  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  String level = 'All';
  String query = '';
  late Future<List<VocabularyWord>> words;

  @override
  void initState() {
    super.initState();
    words = _load();
  }

  Future<List<VocabularyWord>> _load() => context.read<LearningRepositoryProvider>().repository.getWords(level: level, query: query);
  void _refresh() => setState(() => words = _load());

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('শব্দভান্ডার')),
    body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'জার্মান বা বাংলা শব্দ খুঁজুন', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide.none)),
        onChanged: (v) { query = v; _refresh(); },
      )),
      SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: ['All','A1','A2','B1','B2'].map((v) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(label: Text(v), selected: level == v, onSelected: (_) { level = v; _refresh(); }),
      )).toList())),
      Expanded(child: FutureBuilder<List<VocabularyWord>>(
        future: words,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Text('কোনো শব্দ পাওয়া যায়নি।'));
          return ListView.builder(padding: const EdgeInsets.all(14), itemCount: data.length, itemBuilder: (_, i) => _WordCard(word: data[i]));
        },
      )),
    ]),
  );
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word});
  final VocabularyWord word;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text('${word.article == 'verb' || word.article == 'adverb' || word.article == 'adjective' || word.article == 'conjunction' ? '' : '${word.article} '}${word.german}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Chip(label: Text(word.level)),
      ]),
      Text('উচ্চারণ: ${word.pronunciation}  •  ${word.meaningBn}', style: const TextStyle(color: Color(0xFF176B5B), fontWeight: FontWeight.w600)),
      if (word.plural != '—') Text('Plural: ${word.plural}', style: const TextStyle(color: Colors.black54)),
      const Divider(height: 20),
      Text(word.exampleDe, style: const TextStyle(fontWeight: FontWeight.w600)),
      Text(word.exampleBn, style: const TextStyle(color: Colors.black54)),
    ])),
  );
}
