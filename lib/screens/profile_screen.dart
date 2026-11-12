import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.syncService});

  final CloudSyncService syncService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  User? _user;
  bool _savingName = false;
  bool _syncing = false;
  bool _signingOut = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  void _refreshUser() {
    User? user;
    if (Firebase.apps.isNotEmpty) {
      try {
        user = FirebaseAuth.instance.currentUser;
      } catch (_) {
        user = null;
      }
    }
    _user = user;
    _nameController.text = user?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _openAuth() async {
    if (Firebase.apps.isEmpty) {
      setState(() => _message =
          'Firebase সেটআপ সম্পূর্ণ হলে লগইন ও অ্যাকাউন্ট তৈরি করা যাবে। Guest mode-এ শেখা চালিয়ে যেতে পারবেন।');
      return;
    }
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AuthScreen(syncService: widget.syncService),
      ),
    );
    if (mounted) {
      setState(() {
        _message = null;
        _refreshUser();
      });
    }
  }

  Future<void> _saveName() async {
    final user = _user;
    final name = _nameController.text.trim();
    if (user == null || name.isEmpty) {
      setState(() => _message = 'একটি ডিসপ্লে নাম লিখুন।');
      return;
    }
    setState(() {
      _savingName = true;
      _message = null;
    });
    try {
      await user.updateDisplayName(name);
      await user.reload();
      if (!mounted) return;
      setState(() {
        _refreshUser();
        _savingName = false;
        _message = 'আপনার নাম সেভ হয়েছে।';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _savingName = false;
        _message = 'নাম সেভ করা যায়নি। ইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  Future<void> _syncNow() async {
    if (_user == null) return;
    setState(() {
      _syncing = true;
      _message = null;
    });
    try {
      await widget.syncService.syncNow();
      if (!mounted) return;
      setState(() {
        _syncing = false;
        _message = 'আপনার শেখার ডেটা ক্লাউডে ব্যাকআপ হয়েছে।';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _syncing = false;
        _message = 'সিঙ্ক হয়নি। ইন্টারনেট ও Firestore সেটিংস পরীক্ষা করুন।';
      });
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('লগআউট করবেন?'),
        content: const Text(
          'এই ডিভাইসে সংরক্ষিত অফলাইন শেখার ডেটা মুছে যাবে না।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('থাক'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('লগআউট'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _signingOut = true);
    try {
      await AuthService.instance.signOut();
      if (!mounted) return;
      setState(() {
        _refreshUser();
        _signingOut = false;
        _message = 'আপনি লগআউট করেছেন। Guest mode চালু আছে।';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _signingOut = false;
        _message = 'লগআউট করা যায়নি। আবার চেষ্টা করুন।';
      });
    }
  }

  Color _avatarColor(String value) {
    const colors = [
      Color(0xFF176B5B),
      Color(0xFF355C9A),
      Color(0xFF8055A5),
      Color(0xFFB45D42),
      Color(0xFF397A86),
    ];
    final index = value.runes.fold<int>(0, (sum, rune) => sum + rune) %
        colors.length;
    return colors[index];
  }

  String _initial(User user) {
    final name = user.displayName?.trim();
    if (name != null && name.isNotEmpty) return String.fromCharCode(name.runes.first).toUpperCase();
    final email = user.email?.trim() ?? '';
    return email.isEmpty ? '?' : email[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('প্রোফাইল ও অ্যাকাউন্ট')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (user == null) ...[
            const SizedBox(height: 28),
            Icon(Icons.account_circle_outlined,
                size: 92, color: theme.colorScheme.primary),
            const SizedBox(height: 18),
            Text(
              'আপনি Guest mode-এ আছেন',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'অ্যাকাউন্ট তৈরি বা লগইন করলে আপনার শেখার অগ্রগতি ক্লাউডে ব্যাকআপ করতে পারবেন। লগইন ছাড়াও অ্যাপের অফলাইন ফিচার ব্যবহার করতে পারবেন।',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _openAuth,
              icon: const Icon(Icons.login_rounded),
              label: const Text('লগইন / অ্যাকাউন্ট তৈরি'),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: _avatarColor(user.displayName ?? user.email ?? 'D'),
                child: Text(
                  _initial(user),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              user.displayName?.trim().isNotEmpty == true
                  ? user.displayName!
                  : 'আপনার নাম যোগ করুন',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user.email ?? 'ইমেইল পাওয়া যায়নি',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'ডিসপ্লে নাম',
                hintText: 'আপনার নাম লিখুন',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _savingName ? null : _saveName,
              icon: _savingName
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: const Text('নাম সেভ করুন'),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: _syncing ? null : _syncNow,
              icon: _syncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.cloud_sync_outlined),
              label: Text(_syncing ? 'সিঙ্ক হচ্ছে…' : 'এখনই সিঙ্ক করুন'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _signingOut ? null : _signOut,
              icon: const Icon(Icons.logout_rounded),
              label: Text(_signingOut ? 'লগআউট হচ্ছে…' : 'লগআউট'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error),
            ),
          ],
          if (_message != null) ...[
            const SizedBox(height: 18),
            Text(
              _message!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ],
        ],
      ),
    );
  }
}
