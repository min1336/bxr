import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // 임시 데이터
  final String nickname = "The Ghost";
  final String weightClass = "미들급";
  final int height = 185;
  final int reach = 190;
  final int wins = 12;
  final int losses = 1;
  final int knockouts = 8;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 30),
          Text("기본 스탯", style: Theme.of(context).textTheme.headlineSmall),
          const Divider(color: Colors.redAccent),
          _buildStatRow("신장 (Height)", "$height cm", Icons.height),
          _buildStatRow("리치 (Reach)", "$reach cm", Icons.unfold_more),
          const SizedBox(height: 30),
          Text("전적 (Career)", style: Theme.of(context).textTheme.headlineSmall),
          const Divider(color: Colors.redAccent),
          _buildRecordCard(),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // 프로필 수정 기능 구현
              },
              icon: const Icon(Icons.edit),
              label: const Text("프로필 수정"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nickname, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24)),
            const SizedBox(height: 5),
            Text(weightClass, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18, color: Colors.redAccent)),
          ],
        )
      ],
    );
  }

  Widget _buildStatRow(String title, String value, IconData icon) {
    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildRecordCard() {
    int totalFights = wins + losses;
    double winRate = totalFights == 0 ? 0 : (wins / totalFights) * 100;

    return Card(
      color: const Color(0xFF2C2C2C),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRecordItem("승리", wins.toString(), Colors.blue),
            _buildRecordItem("KO", knockouts.toString(), Colors.redAccent),
            _buildRecordItem("패배", losses.toString(), Colors.grey),
            _buildRecordItem("승률", "${winRate.toStringAsFixed(1)}%", Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }
}