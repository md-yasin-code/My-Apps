import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.syncService});
  final CloudSyncService syncService;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String _friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use': return 'এই ইমেইল দিয়ে আগে থেকেই অ্যাকাউন্ট আছে।';
        case 'invalid-email': return 'সঠিক ইমেইল ঠিকানা লিখুন।';
        case 'weak-password': return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের দিন।';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential': return 'ইমেইল অথবা পাসওয়ার্ড সঠিক নয়।';
        case 'network-request-failed': return 'ইন্টারনেট সংযোগ পরীক্ষা করুন।';
      }
    }
    return 'কাজটি সম্পন্ন হয়নি। Firebase সেটআপ ও ইন্টারনেট সংযোগ পরীক্ষা করুন।';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _busy = true; _message = null; });
    try {
      if (_register) {
        await AuthService.instance.register(_email.text, _password.text);
      } else {
        await AuthService.instance.signIn(_email.text, _password.text);
      }
      await widget.syncService.syncNow();
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) setState(() => _message = _friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty) {
      setState(() => _message = 'আগে আপনার ইমেইল ঠিকানাটি লিখুন।');
      return;
    }
    try {
      await AuthService.instance.sendPasswordReset(_email.text);
      if (mounted) setState(() => _message = 'পাসওয়ার্ড রিসেটের ইমেইল পাঠানো হয়েছে।');
    } catch (error) {
      if (mounted) setState(() => _message = _friendlyError(error));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('অ্যাকাউন্ট ও ক্লাউড সিঙ্ক')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.cloud_sync_rounded, size: 58,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 14),
                Text(_register ? 'নতুন অ্যাকাউন্ট তৈরি করুন' : 'আপনার অ্যাকাউন্টে প্রবেশ করুন',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('আপনার শেখার অগ্রগতি এই ডিভাইসে অফলাইনে থাকবে। লগইন করলে ব্যক্তিগত ক্লাউড ব্যাকআপ তৈরি হবে।',
                    textAlign: TextAlign.center),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'ইমেইল', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
                  validator: (v) => v == null || !v.contains('@') ? 'সঠিক ইমেইল লিখুন।' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(labelText: 'পাসওয়ার্ড', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure))),
                  validator: (v) => v == null || v.length < 6 ? 'কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড দিন।' : null,
                ),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _resetPassword, child: const Text('পাসওয়ার্ড ভুলে গেছেন?'))),
                if (_message != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_register ? 'অ্যাকাউন্ট তৈরি করুন' : 'লগইন ও সিঙ্ক করুন'),
                  ),
                ),
                TextButton(
                  onPressed: _busy ? null : () => setState(() { _register = !_register; _message = null; }),
                  child: Text(_register ? 'আগে থেকেই অ্যাকাউন্ট আছে? লগইন করুন' : 'নতুন ব্যবহারকারী? অ্যাকাউন্ট তৈরি করুন'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
