import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'user_list_screen.dart';
import 'placeholder_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ProfileScreen(),
    const UserListScreen(),
    const PlaceholderScreen(title: '경기 기록'),
    const PlaceholderScreen(title: 'AI 전략 분석'),
    const PlaceholderScreen(title: '장비 스토어'),
    const PlaceholderScreen(title: '트레이닝 타이머'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 스탯',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '유저 목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'AI 분석',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: '스토어',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: '타이머',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // 4개 이상일 때 필요
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '내 프로필 (게임 스탯)';
      case 1:
        return '유저 목록';
      case 2:
        return '경기 기록';
      case 3:
        return 'AI 전략 분석';
      case 4:
        return '복싱 장비 스토어';
      case 5:
        return '트레이닝 타이머';
      default:
        return 'Boxing Niche';
    }
  }
}