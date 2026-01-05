import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';

/// OTP Verification Screen - Auto-proceed when code is correct
class OtpScreen extends StatefulWidget {
  final String? email;
  const OtpScreen({super.key, this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  bool _isError = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  // Simulated correct OTP
  static const String _correctOtp = '123456';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      bool shouldContinue = _resendCountdown > 0;
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
        }
      });
      return shouldContinue && mounted;
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  void _onCodeChanged(int index, String value) {
    setState(() => _isError = false);

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if all fields are filled
    if (_enteredOtp.length == 6) {
      _verifyOtp();
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    if (_isVerifying) return;

    setState(() => _isVerifying = true);

    // Simulate verification delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    if (_enteredOtp == _correctOtp) {
      // Success - navigate to home
      context.go('/home');
    } else {
      // Error - shake and show error
      setState(() {
        _isError = true;
        _isVerifying = false;
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _resendCode() {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _resendCountdown = 60;
      _isError = false;
      for (var c in _controllers) {
        c.clear();
      }
    });
    _focusNodes[0].requestFocus();
    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Kode OTP baru telah dikirim'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email ?? 'email@example.com';
    final maskedEmail = _maskEmail(email);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back Button
              GestureDetector(
                onTap: () => context.go('/signup'),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white70, size: 20),
                ),
              ),

              const Spacer(flex: 2),

              // Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.email_outlined,
                      size: 36, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Center(
                child: Text(
                  'Verifikasi Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Center(
                child: Text(
                  'Masukkan kode 6 digit yang dikirim ke\n$maskedEmail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOtpField(index)),
              ),

              const SizedBox(height: 16),

              // Error Message
              if (_isError)
                Center(
                  child: Text(
                    'Kode tidak valid. Silakan coba lagi.',
                    style: TextStyle(color: Colors.red.shade400, fontSize: 13),
                  ),
                ),

              // Loading indicator
              if (_isVerifying)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),

              const Spacer(flex: 1),

              // Resend Code
              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: _resendCode,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14),
                            children: [
                              const TextSpan(text: 'Tidak menerima kode? '),
                              TextSpan(
                                text: 'Kirim Ulang',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Text(
                        'Kirim ulang kode dalam ${_resendCountdown}s',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4), fontSize: 14),
                      ),
              ),

              const Spacer(flex: 2),

              // Hint
              Center(
                child: Text(
                  'Demo: Gunakan kode 123456',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.3), fontSize: 12),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: _isError
            ? Colors.red.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isError
              ? Colors.red.shade400
              : _focusNodes[index].hasFocus
                  ? AppColors.primary
                  : Colors.white.withOpacity(0.1),
          width: _focusNodes[index].hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          color: _isError ? Colors.red.shade300 : Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _onCodeChanged(index, value),
        onTap: () => setState(() {}),
      ),
    );
  }

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
  }
}
