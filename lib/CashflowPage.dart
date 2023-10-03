import 'package:flutter/material.dart';
import 'models/database_helper.dart';

class CashflowPage extends StatefulWidget {
  final String username;

  CashflowPage({required this.username});
  @override
  _CashflowPageState createState() => _CashflowPageState();
}

class _CashflowPageState extends State<CashflowPage> {
  final dbHelper = DatabaseHelper(); // Inisialisasi DatabaseHelper

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Flow'),
      ),
      body: FutureBuilder(
        future: dbHelper.getAllTransactions(widget.username), // Ganti dengan username pengguna yang sesuai
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final transactions = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];

                // Tentukan ikon berdasarkan transaction_type
                Icon icon;
                if (transaction['transaction_type'] == 'Pemasukan') {
                  icon = Icon(Icons.arrow_back,
                      color: Colors.green); // Panah ke kiri untuk pemasukkan
                } else if (transaction['transaction_type'] == 'Pengeluaran') {
                  icon = Icon(Icons.arrow_forward,
                      color: Colors.red); // Panah ke kanan untuk pengeluaran
                } else {
                  icon =
                      Icon(Icons.info); // Ikon default jika tipe tidak dikenali
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Warna garis tepi
                      width: 1.0, // Lebar garis tepi
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Bentuk border
                  ),
                  child: ListTile(
                    title: Text('Tanggal: ${transaction['transaction_date']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nominal: ${transaction['amount']}'),
                        Text('Keterangan: ${transaction['description']}'),
                        Text('Tipe: ${transaction['transaction_type']}'),
                      ],
                    ),
                    trailing: icon, // Ikon akan muncul di sisi kiri ListTile
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
