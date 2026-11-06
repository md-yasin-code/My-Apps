import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/vocabulary_word.dart';
import '../services/speech_service.dart';
import '../widgets/glass_surface.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key, this.showAppBar = true});
  final bool showAppBar;
  @override State<VocabularyScreen> createState() => _VocabularyScreenState();
}
class _VocabularyScreenState extends State<VocabularyScreen> {
  String level = 'All', query = '', wordType = 'All';
  late Future<List<VocabularyWord>> words;
  @override void initState() { super.initState(); words = _load(); }
  Future<List<VocabularyWord>> _load() => context.read<LearningRepositoryProvider>().repository.getWords(level: level, query: query, wordType: wordType);
  void _refresh() => setState(() => words = _load());
  @override Widget build(BuildContext context) => Scaffold(
    appBar: widget.showAppBar ? AppBar(title: const Text('শব্দভান্ডার')) : null,
    body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 6), child: TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'জার্মান বা বাংলা শব্দ খুঁজুন', filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide.none)),
        onChanged: (v) { query = v; _refresh(); },
      )),
      _filters(['All','A1','A2','B1','B2'], level, (v) { level = v; _refresh(); }),
      _filters(['All','noun','verb','adjective','adverb','conjunction','preposition'], wordType, (v) { wordType = v; _refresh(); }),
      Expanded(child: FutureBuilder<List<VocabularyWord>>(future: words, builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('শব্দ লোড করা যায়নি। আবার চেষ্টা করুন।'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;
        if (data.isEmpty) return const Center(child: Text('কোনো শব্দ পাওয়া যায়নি।'));
        return ListView.builder(padding: const EdgeInsets.all(14), itemCount: data.length, itemBuilder: (_, i) => TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: 1), duration: Duration(milliseconds: 260 + (i % 5) * 45), curve: Curves.easeOutCubic, builder: (context, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 12 * (1 - value)), child: child)), child: _WordCard(word: data[i], onChanged: _refresh)));
      })),
    ]),
  );
  Widget _filters(List<String> values, String selected, ValueChanged<String> onSelect) => SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: values.map((v) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: ChoiceChip(label: Text(v == 'All' ? 'সব' : v), selected: selected == v, onSelected: (_) => onSelect(v)))).toList()));
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word, required this.onChanged});
  final VocabularyWord word; final VoidCallback onChanged;
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: GlassSurface(
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(_displayHeadword(word), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3))),
          IconButton.filledTonal(tooltip: 'জার্মান উচ্চারণ শুনুন', onPressed: () => _speak(context, _displayHeadword(word)), icon: const Icon(Icons.volume_up_rounded)),
          IconButton(
            tooltip: word.isFavorite ? 'পছন্দের তালিকা থেকে সরান' : 'পছন্দের তালিকায় রাখুন',
            icon: Icon(word.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: word.isFavorite ? Colors.redAccent : null),
            onPressed: () async { await context.read<LearningRepositoryProvider>().repository.setFavorite(itemType: 'word', itemId: word.id, favorite: !word.isFavorite); onChanged(); },
          ),
        ]),
        const SizedBox(height: 4),
        Text('${_typeLabel(word.wordType)}  •  ${word.level}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        Text('উচ্চারণ: ${word.pronunciation}  •  ${word.meaningBn}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.45)),
        if (word.plural != '—') Padding(padding: const EdgeInsets.only(top: 5), child: Text('বহুবচন: ${word.plural}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(word.exampleDe, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.45))),
          IconButton(visualDensity: VisualDensity.compact, tooltip: 'উদাহরণের উচ্চারণ শুনুন', onPressed: () => _speak(context, word.exampleDe), icon: const Icon(Icons.volume_up_outlined, size: 20)),
        ]),
        Text(word.exampleBn, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.45)),
      ]),
    ),
  );

  Future<void> _speak(BuildContext context, String text) async {
    try {
      await SpeechService.instance.speakGerman(text);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('জার্মান ভয়েস পাওয়া যায়নি। ফোনের Text-to-Speech সেটিংসে German voice ইনস্টল করুন।')));
      }
    }
  }
}
String _displayHeadword(VocabularyWord word) { final noun = word.wordType == 'noun' || ['der', 'die', 'das'].contains(word.article); if (!noun) return word.german; final prefix = '${word.article} '; return word.german.startsWith(prefix) ? word.german : '$prefix${word.german}'; }
String _typeLabel(String type) => const {'noun':'বিশেষ্য','verb':'ক্রিয়া','adjective':'বিশেষণ','adverb':'ক্রিয়া বিশেষণ','conjunction':'সংযোজক','preposition':'পদান্বয়ী অব্যয়' }[type] ?? type;
