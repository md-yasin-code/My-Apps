import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/lesson.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});
  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  String level = 'All';
  late Future<List<Lesson>> lessons;
  @override
  void initState() { super.initState(); lessons = _load(); }
  Future<List<Lesson>> _load() => context.read<LearningRepositoryProvider>().repository.getLessons(level: level);
  void _filter(String v) => setState(() { level = v; lessons = _load(); });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('গ্রামার ও লেসন')),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Wrap(spacing: 8, children: ['All','A1','A2','B1','B2'].map((v) => ChoiceChip(label: Text(v), selected: level == v, onSelected: (_) => _filter(v))).toList())),
      Expanded(child: FutureBuilder<List<Lesson>>(future: lessons, builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return ListView.builder(padding: const EdgeInsets.all(14), itemCount: snapshot.data!.length, itemBuilder: (_, i) {
          final l = snapshot.data![i];
          return Card(child: ExpansionTile(
            onExpansionChanged: (open) { if (open) context.read<LearningRepositoryProvider>().repository.recordProgress(itemType: 'lesson', itemId: l.id, correct: true); },
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(tooltip: l.isFavorite ? 'পছন্দের তালিকা থেকে সরান' : 'পছন্দের তালিকায় রাখুন', icon: Icon(l.isFavorite ? Icons.favorite : Icons.favorite_border), onPressed: () async { await context.read<LearningRepositoryProvider>().repository.setFavorite(itemType: 'lesson', itemId: l.id, favorite: !l.isFavorite); setState(() => lessons = _load()); }), const Icon(Icons.expand_more)]),
            title: Text(l.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: CircleAvatar(child: Text(l.level)),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Align(alignment: Alignment.centerLeft, child: Text(l.summary)),
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerLeft, child: Text(l.rule, style: const TextStyle(height: 1.5))),
              const SizedBox(height: 10),
              Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFEAF4F0), borderRadius: BorderRadius.circular(12)), child: Text(l.example, style: const TextStyle(fontWeight: FontWeight.w600))),
            ],
          ));
        });
      })),
    ]),
  );
}
