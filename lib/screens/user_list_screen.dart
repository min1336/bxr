import 'package:flutter/material.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  // 임시 유저 데이터
  final List<Map<String, String>> users = const [
    {'name': 'Iron Mike', 'record': '50W-6L-44KO', 'class': '헤비급'},
    {'name': 'Pac-Man', 'record': '62W-8L-39KO', 'class': '웰터급'},
    {'name': 'Pretty Boy', 'record': '50W-0L-27KO', 'class': '웰터급'},
    {'name': 'Canelo', 'record': '57W-2L-39KO', 'class': '라이트헤비급'},
    {'name': 'GGG', 'record': '42W-2L-37KO', 'class': '미들급'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          color: const Color(0xFF2C2C2C),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
            title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${user['class']} / ${user['record']}"),
            trailing: ElevatedButton(
              onPressed: () {
                // 대결 신청 기능 로직
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${user['name']}에게 대결을 신청했습니다.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                foregroundColor: Colors.white,
              ),
              child: const Text('대결 신청'),
            ),
          ),
        );
      },
    );
  }
}