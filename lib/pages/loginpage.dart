import 'package:design/pages/viewmodels/loginpage_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../base/base_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPageViewModel, LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: kDebugMode ? 'saban307cepni@gmail.com' : '');
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? '123456Aa' : '');
  final TextEditingController _resetEmailController = TextEditingController();

  bool _showLogin = true;
  bool _showForgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showForgotPassword
            ? _buildForgotPasswordForm()
            : (_showLogin ? _buildLoginForm() : _buildRegisterForm()),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            'assets/logo.svg',
            width: MediaQuery.of(context).size.width * 0.35,
            colorFilter: ColorFilter.mode(
              Colors.orange.shade800,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Mail adresinizi giriniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Şifre',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Lütfen şifrenizi giriniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              viewModel
                  .signIn(_emailController.text, _passwordController.text)
                  .then((value) => Navigator.pushNamed(
                        context,
                        '/root',
                      ).onError((e, stackTrace) => (e) {
                            if (e.code == 'invalid-email') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mail adresi geçersiz.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              print('Email is invalid.');
                            } else if (e.code == 'invalid-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Şifre geçersiz.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              print('Password is invalid.');
                            } else if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kullanıcı bulunamadı.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              print('User not found.');
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Şifre yanlış.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              print('Wrong password.');
                            }
                          }));
            },
            child: const Text('Giriş yap'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showForgotPassword = true;
                    _showLogin = false;
                  });
                },
                child: const Text('Şifremi Unuttum'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showLogin = false;
                  });
                },
                child: const Text('Kayıt ol '),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            'assets/logo.svg',
            width: MediaQuery.of(context).size.width * 0.35,
            colorFilter: ColorFilter.mode(
              Colors.orange.shade800,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Mail adresinizi giriniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Şifre',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Şifrenizi giriniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              viewModel
                  .registerUser(_emailController.text, _passwordController.text)
                  .then((value) => Navigator.pushNamed(context, '/root')
                      .onError((error, stackTrace) => (e) {
                            if (e.code == 'weak-password') {
                              print('Şifre çok zayıf');
                            } else if (e.code == 'email-already-in-use') {
                              print('Bu mail adresi zaten kullanılıyor');
                            }
                          }));
            },
            child: const Text('Kayıt ol '),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showForgotPassword = true;
                    _showLogin = true;
                  });
                },
                child: const Text('Şifremi Unuttum'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showLogin = true;
                  });
                },
                child: const Text('Giriş yap'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            'assets/logo.svg',
            width: MediaQuery.of(context).size.width * 0.35,
            colorFilter: ColorFilter.mode(
              Colors.orange.shade800,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Lütfen email adresinizi giriniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              viewModel
                  .resetPassword(_resetEmailController.text)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Şifre sıfırlama maili gönderildi"),
                          duration: Duration(seconds: 2),
                        ),
                      ));
            },
            child: const Text('Şifreni sıfırla'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showForgotPassword = false;
                    _showLogin = true;
                  });
                },
                child: const Text('Giriş yap'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
