import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class FavoritesScreen extends StatefulWidget { const FavoritesScreen({super.key}); @override State<FavoritesScreen> createState() => _FavoritesScreenState(); }
class _FavoritesScreenState extends State<FavoritesScreen> {
  String type = 'word';
  late Future<List<Map<String, Object?>>> items;
  @override void initState() { super.initState(); items = _load(); }
  Future<List<Map<String, Object?>>> _load() => context.read<LearningRepositoryProvider>().repository.getFavorites(itemType: type);
  void _switch(String value) => setState(() { type = value; items = _load(); });
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('পছন্দের তালিকা')), body: Column(children: [
    Padding(padding: const EdgeInsets.all(12), child: SegmentedButton<String>(segments: const [ButtonSegment(value: 'word', label: Text('শব্দ')), ButtonSegment(value: 'lesson', label: Text('লেসন'))], selected: {type}, onSelectionChanged: (v) => _switch(v.first))),
    Expanded(child: FutureBuilder<List<Map<String, Object?>>>(future: items, builder: (context, snapshot) {
      if (snapshot.hasError) return const Center(child: Text('তালিকা লোড করা যায়নি।'));
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final rows = snapshot.data!;
      if (rows.isEmpty) return const Center(child: Text('এখনো কিছু পছন্দের তালিকায় যোগ করা হয়নি।'));
      return ListView.builder(itemCount: rows.length, itemBuilder: (context, i) { final row = rows[i]; final title = type == 'word' ? '${row['article']} ${row['german']}' : row['title'].toString(); final subtitle = type == 'word' ? '${row['meaning_bn']} • ${row['level']}' : '${row['level']} • ${row['summary']}'; return ListTile(leading: const Icon(Icons.favorite, color: Colors.red), title: Text(title), subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis), trailing: IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () async { await context.read<LearningRepositoryProvider>().repository.setFavorite(itemType: type, itemId: row['id'] as int, favorite: false); setState(() => items = _load()); })); });
    })),
  ]));
}