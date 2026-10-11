import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../theme.dart';
import '../widgets/brand_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _registering = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.films);
  }

  void _toggleMode() {
    setState(() {
      _registering = !_registering;
      _agreedToTerms = false;
      _obscurePassword = true;
      _obscureConfirmation = true;
    });
    _formKey.currentState?.reset();
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
                        if (_registering) ...[
                          TextFormField(
                            key: const Key('firstNameField'),
                            controller: _firstNameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.givenName],
                            decoration: const InputDecoration(
                              labelText: 'First name',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: 21,
                              ),
                            ),
                            validator: (value) {
                              if ((value?.trim() ?? '').isEmpty) {
                                return 'Enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            key: const Key('lastNameField'),
                            controller: _lastNameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.familyName],
                            decoration: const InputDecoration(
                              labelText: 'Last name',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: 21,
                              ),
                            ),
                            validator: (value) {
                              if ((value?.trim() ?? '').isEmpty) {
                                return 'Enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],
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
                          textInputAction: _registering
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onFieldSubmitted: _registering
                              ? null
                              : (_) => _continue(),
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
                        if (_registering) ...[
                          const SizedBox(height: 14),
                          TextFormField(
                            key: const Key('confirmPasswordField'),
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmation,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _continue(),
                            autofillHints: const [AutofillHints.newPassword],
                            decoration: InputDecoration(
                              labelText: 'Confirm password',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                size: 21,
                              ),
                              suffixIcon: IconButton(
                                tooltip: _obscureConfirmation
                                    ? 'Show password confirmation'
                                    : 'Hide password confirmation',
                                onPressed: () => setState(
                                  () => _obscureConfirmation =
                                      !_obscureConfirmation,
                                ),
                                icon: Icon(
                                  _obscureConfirmation
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 21,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          FormField<bool>(
                            key: const Key('termsField'),
                            initialValue: false,
                            validator: (value) => value == true
                                ? null
                                : 'Accept the Terms and Conditions to continue',
                            builder: (field) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        key: const Key('termsCheckbox'),
                                        value: _agreedToTerms,
                                        onChanged: (value) {
                                          setState(
                                            () =>
                                                _agreedToTerms = value ?? false,
                                          );
                                          field.didChange(value ?? false);
                                        },
                                      ),
                                      Expanded(
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            const Text(
                                              'I agree to the ',
                                              style: TextStyle(
                                                color: SavannahColors.muted,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Terms and Conditions will be available here.',
                                                      ),
                                                    ),
                                                  ),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              child: const Text(
                                                'Terms and Conditions',
                                                style: TextStyle(
                                                  color: SavannahColors.gold,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (field.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        field.errorText!,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
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
                          const SizedBox(height: 12),
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
                              onPressed: _toggleMode,
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
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.films),
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
