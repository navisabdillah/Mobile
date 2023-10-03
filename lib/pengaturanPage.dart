import 'package:flutter/material.dart';
import 'models/database_helper.dart'; // Gantilah impor sesuai dengan aplikasi Anda

class pengaturanPage extends StatefulWidget {
  final String username;

  pengaturanPage({required this.username});

  @override
  pengaturanPageState createState() => pengaturanPageState();
}

class pengaturanPageState extends State<pengaturanPage> {
  final dbHelper = DatabaseHelper();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

// Tambahkan informasi Anda di sini
  final String namaPengembang = "Muhammad Navis Abdillah";
  final String nimPengembang = "1941720147";
  final String fotoProfilPengembang =
      "images/Avatar.jpg"; // Ganti dengan path gambar profil Anda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Saat Ini',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final isPasswordCorrect =
                    await dbHelper.login(widget.username, currentPassword);
                if (isPasswordCorrect) {
                  await dbHelper.changePassword(widget.username, newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Password berhasil diganti.'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Password saat ini salah.'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
              child: Text('Simpan'),
            ),
            SizedBox(height: 32),
            // Tambahkan widget untuk menampilkan foto, nama, dan NIM Anda
            CircleAvatar(
              radius: 50, // Sesuaikan dengan ukuran yang Anda inginkan
              backgroundImage: AssetImage(fotoProfilPengembang),
            ),
            SizedBox(height: 16),
            Text(
              "Nama: $namaPengembang",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "NIM: $nimPengembang",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
