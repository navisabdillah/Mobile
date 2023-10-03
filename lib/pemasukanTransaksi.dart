import 'package:flutter/material.dart';
import 'models/database_helper.dart';
import 'package:intl/intl.dart';
import 'homePage.dart';

class pemasukanTransaksi extends StatefulWidget {
  final String username;

  pemasukanTransaksi({required this.username});
  
  @override
  pemasukanTransaksiState createState() => pemasukanTransaksiState();
}

class pemasukanTransaksiState extends State<pemasukanTransaksi> {
  TextEditingController nominalController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: '01/01/2021');
  TextEditingController keteranganController = TextEditingController();

  final dbHelper = DatabaseHelper(); // Inisialisasi DatabaseHelper

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021, 1, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: 'Tanggal'),
                    enabled: false, // Agar tidak dapat diedit secara manual
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
            TextField(
              controller: nominalController,
              decoration: InputDecoration(labelText: 'Nominal'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: keteranganController,
              decoration: InputDecoration(labelText: 'Keterangan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nominal = double.parse(nominalController.text);
                final date = dateController.text;
                final keterangan = keteranganController.text;

                // Memanggil metode saveTransaction untuk menyimpan transaksi
                await dbHelper.saveTransaction(
                  widget.username,
                  date,
                  nominal,
                  keterangan,
                  'Pemasukan', // Ganti dengan jenis transaksi yang sesuai
                );

                // Navigasi kembali ke halaman beranda setelah transaksi disimpan
                final userData = await dbHelper.getUserData(widget.username);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(userData),
                    ),
                  );
              },
              child: Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                dateController.text = '01/01/2021';
                keteranganController.text="";
                nominalController.text="";
              },
              child: Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
