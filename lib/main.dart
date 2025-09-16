import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';

void main() async {
  // Flutter 앱이 실행되기 전에 Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BoxingApp());
}

class BoxingApp extends StatelessWidget {
  const BoxingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 앱 전체에서 인증 서비스를 사용할 수 있도록 Provider 설정
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Boxing Niche',
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          appBarTheme: const AppBarTheme(
            color: Color(0xFF2C2C2C),
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF2C2C2C),
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.grey,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// 로그인 상태에 따라 보여줄 화면을 결정하는 위젯
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          // 유저 객체가 null이면 로그인 화면, 아니면 메인 화면을 보여줌
          return user == null ? const AuthScreen() : const MainScreen();
        }
        // 연결 중일 때 로딩 인디케이터 표시
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}