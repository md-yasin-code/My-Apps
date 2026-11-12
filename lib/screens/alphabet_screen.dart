import 'package:flutter/material.dart';

import '../data/alphabet_data.dart';
import '../services/speech_service.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final _textController = TextEditingController();
  bool _speakingText = false;
  String? _speakingLetter;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _speakLetter(AlphabetLetter letter) async {
    setState(() => _speakingLetter = letter.character);
    try {
      await SpeechService.instance.speakGerman(letter.spokenName);
    } catch (_) {
      if (mounted) _showVoiceHelp();
    } finally {
      if (mounted) setState(() => _speakingLetter = null);
    }
  }

  Future<void> _speakText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('শোনার জন্য একটি জার্মান শব্দ বা বাক্য লিখুন।')),
      );
      return;
    }
    setState(() => _speakingText = true);
    try {
      await SpeechService.instance.speakGerman(text);
    } catch (_) {
      if (mounted) _showVoiceHelp();
    } finally {
      if (mounted) setState(() => _speakingText = false);
    }
  }

  void _showVoiceHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('German voice পাওয়া যায়নি। Android Text-to-Speech সেটিংসে German (de-DE) voice data ইনস্টল করুন।'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('অক্ষর ও উচ্চারণ')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            'জার্মান বর্ণমালা',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'অক্ষরে ট্যাপ করলে জার্মান ভাষায় তার নাম শুনতে পাবেন।',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: germanAlphabet.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.12,
            ),
            itemBuilder: (context, index) {
              final letter = germanAlphabet[index];
              final active = _speakingLetter == letter.character;
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _speakLetter(letter),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          letter.character,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          letter.pronunciationBn,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 3),
                        Icon(
                          active ? Icons.volume_up_rounded : Icons.play_circle_outline,
                          size: 17,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'শব্দ বা বাক্য শুনুন',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text('এখানে জার্মান শব্দ বা বাক্য লিখে উচ্চারণ শুনুন।'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'যেমন: Guten Morgen!',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.translate_rounded),
                    ),
                    onSubmitted: (_) => _speakText(),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _speakingText ? null : _speakText,
                    icon: _speakingText
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.volume_up_rounded),
                    label: Text(_speakingText ? 'শোনা হচ্ছে…' : 'শুনুন'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'নোট: ä, ö, ü হলো umlaut-যুক্ত অক্ষর। ß-কে Eszett বলা হয়। বাংলা উচ্চারণগুলো কাছাকাছি ধারণা দেওয়ার জন্য; সঠিক ধ্বনি শুনে অনুশীলন করুন।',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}
