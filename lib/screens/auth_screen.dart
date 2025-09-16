import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _nickname = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // 키보드 내리기

    if (isValid) {
      _formKey.currentState!.save();
      final authService = Provider.of<AuthService>(context, listen: false);

      authService.submitAuthForm(
        email: _email.trim(),
        password: _password.trim(),
        nickname: _nickname.trim(),
        isLogin: _isLogin,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'BOXING NICHE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 40),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('nickname'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 2) {
                        return '2글자 이상의 닉네임을 입력하세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nickname = value!;
                    },
                    decoration: InputDecoration(labelText: '닉네임'),
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return '올바른 이메일 주소를 입력하세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: '이메일 주소'),
                ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return '비밀번호는 6자리 이상이어야 합니다.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: true,
                  decoration: InputDecoration(labelText: '비밀번호'),
                ),
                SizedBox(height: 20),
                if (authService.isLoading) CircularProgressIndicator(),
                if (!authService.isLoading)
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? '로그인' : '회원가입'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                if (!authService.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? '새로운 계정 만들기' : '이미 계정이 있습니다',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}