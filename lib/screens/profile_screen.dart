import 'dart:developer'; // log를 사용하기 위해 import
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UniqueKey _key = UniqueKey();

  Future<DocumentSnapshot> _getUserData() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  void _navigateToEditScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    if (result == true) {
      setState(() {
        _key = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      key: _key,
      future: _getUserData(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // 어떤 오류인지 콘솔에 출력
          log("Firebase 데이터 로딩 오류: ${snapshot.error}");
          return const Center(child: Text("데이터를 불러오는 중 오류가 발생했습니다."));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("사용자 정보를 찾을 수 없습니다."));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final String nickname = userData['nickname'] ?? 'N/A';
        final String weightClass = "미들급";
        final int height = userData['height'] ?? 0;
        final int reach = userData['reach'] ?? 0;
        final int wins = userData['wins'] ?? 0;
        final int losses = userData['losses'] ?? 0;
        final int knockouts = userData['knockouts'] ?? 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, nickname, weightClass),
              const SizedBox(height: 30),
              Text("기본 스탯", style: Theme.of(context).textTheme.headlineSmall),
              const Divider(color: Colors.redAccent),
              _buildStatRow("신장 (Height)", "$height cm", Icons.height),
              _buildStatRow("리치 (Reach)", "$reach cm", Icons.unfold_more),
              const SizedBox(height: 30),
              Text("전적 (Career)", style: Theme.of(context).textTheme.headlineSmall),
              const Divider(color: Colors.redAccent),
              _buildRecordCard(wins, losses, knockouts),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _navigateToEditScreen,
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
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, String nickname, String weightClass) {
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

  Widget _buildRecordCard(int wins, int losses, int knockouts) {
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