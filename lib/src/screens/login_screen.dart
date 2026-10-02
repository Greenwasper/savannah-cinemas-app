import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/brand_mark.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _registering = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, animation, _) =>
            FadeTransition(opacity: animation, child: const HomeScreen()),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(right: -72, top: -38, child: _GoldenOrbit()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: BrandMark(),
                        ),
                        const SizedBox(height: 82),
                        Text(
                          _registering
                              ? 'Create your\naccount'
                              : 'Welcome\nback',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _registering
                              ? 'Book seats, keep your ticket stubs and earn points.'
                              : 'Sign in to see your bookings, watchlist and Savannah Rewards.',
                          style: const TextStyle(
                            color: SavannahColors.muted,
                            height: 1.5,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          key: const Key('emailField'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'you@example.com',
                            prefixIcon: Icon(
                              Icons.mail_outline_rounded,
                              size: 21,
                            ),
                          ),
                          validator: (value) {
                            if (!_registering) return null;
                            final email = value?.trim() ?? '';
                            if (email.isEmpty || !email.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          key: const Key('passwordField'),
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _continue(),
                          autofillHints: [
                            _registering
                                ? AutofillHints.newPassword
                                : AutofillHints.password,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 21,
                            ),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 21,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (!_registering) return null;
                            if ((value ?? '').length < 6) {
                              return 'Use at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        if (!_registering)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Password reset is coming soon.',
                                      ),
                                    ),
                                  ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: SavannahColors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 20),
                        FilledButton(
                          key: const Key('signInButton'),
                          onPressed: _continue,
                          child: Text(
                            _registering ? 'Create account' : 'Sign in',
                          ),
                        ),
                        const SizedBox(height: 17),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              _registering
                                  ? 'Already have an account?'
                                  : 'New to Savannah?',
                              style: const TextStyle(
                                color: SavannahColors.muted,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _registering = !_registering),
                              child: Text(
                                _registering ? 'Sign in' : 'Create account',
                                style: const TextStyle(
                                  color: SavannahColors.gold,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) => const HomeScreen(),
                                ),
                              ),
                          child: const Text(
                            'Continue as guest',
                            style: TextStyle(color: SavannahColors.muted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldenOrbit extends StatelessWidget {
  const _GoldenOrbit();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment(-.3, -.35),
          colors: [Color(0xFFFFE3A6), SavannahColors.gold, SavannahColors.clay],
          stops: [0, .55, 1],
        ),
        boxShadow: [
          BoxShadow(color: Color(0x20EDAA3B), spreadRadius: 25),
          BoxShadow(color: Color(0x10EDAA3B), spreadRadius: 52),
        ],
      ),
    );
  }
}
