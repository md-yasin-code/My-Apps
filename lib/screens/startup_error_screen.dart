import 'package:flutter/material.dart';

class StartupErrorScreen extends StatefulWidget {
  const StartupErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final Future<void> Function() onRetry;

  @override
  State<StartupErrorScreen> createState() => _StartupErrorScreenState();
}

class _StartupErrorScreenState extends State<StartupErrorScreen> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await widget.onRetry();
    if (mounted) setState(() => _retrying = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 58, color: colors.error),
                  const SizedBox(height: 18),
                  Text(
                    'অ্যাপ চালু করা যাচ্ছে না',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'আপনার শেখার ডেটা নিরাপদ রাখতে অ্যাপটি বন্ধ না করে সমস্যার তথ্য দেখানো হচ্ছে। ইন্টারনেট ছাড়াই আবার চেষ্টা করতে পারেন।',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.errorContainer.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SelectableText(
                      widget.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _retrying ? null : _retry,
                      icon: _retrying
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh_rounded),
                      label: Text(_retrying ? 'আবার চেষ্টা হচ্ছে…' : 'আবার চেষ্টা করুন'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'সমস্যাটি থাকলে এই Error details-এর স্ক্রিনশট ডেভেলপারকে পাঠান।',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
