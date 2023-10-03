import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pemasukanTransaksi.dart';
import 'CashflowPage.dart';
import 'pengeluaranTransaksi.dart';
import 'pengaturanPage.dart';
import 'models/database_helper.dart';

class HomePage extends StatefulWidget {
  final Map userData;

  HomePage(this.userData);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<String>(
              future: dbHelper.getTotalPengeluaran(widget.userData['username']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final totalPengeluaran = snapshot.data ?? 0.0;
                  return Text('Total Pengeluaran: $totalPengeluaran',
                      style: TextStyle(color: Colors.red));
                }
              },
            ),
            FutureBuilder<String>(
              future: dbHelper.getTotalPemasukan(widget.userData['username']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final totalPemasukan = snapshot.data ?? 0.0;
                  return Text(
                    'Total Pemasukan: $totalPemasukan',
                    style: TextStyle(color: Colors.green),
                  );
                }
              },
            ),

            // ElevatedButton(
            //     onPressed: () {
            //       // dbHelper.getTotalPengeluaran(widget.userData['username']);
            //       dbHelper.deleteAllTransactions();
            //     },
            //     child: Text("hapus")),
            SizedBox(height: 20),
            Text('Grafik Pemasukan dan Pengeluaran per Hari:'),
            Container(
              width: 300,
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 1,
                  maxX: 7,
                  minY: 0,
                  maxY: 100, // Gantilah dengan nilai maksimum yang sesuai
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(1, 20), // Ganti dengan data yang sesuai
                        FlSpot(2, 35),
                        FlSpot(3, 40),
                        FlSpot(4, 55),
                        FlSpot(5, 45),
                        FlSpot(6, 60),
                        FlSpot(7, 80),
                      ],
                      isCurved: true,
                      colors: [const Color(0xff4caf50)],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: <Widget>[
                  MyImageButton(
                    imageUrl: 'images/profit.png',
                    label: "Pemasukan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pemasukanTransaksi(
                              username: widget.userData['username']),
                        ),
                      );
                    },
                  ),
                  MyImageButton(
                    imageUrl: 'images/pengeluaran.png',
                    label: "Pengeluaran",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pengeluaranTransaksi(
                              username: widget.userData['username']),
                        ),
                      );
                    },
                  ),
                  MyImageButton(
                    imageUrl: 'images/cashFlow.png',
                    label: "Cash Flow",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CashflowPage(
                              username: widget.userData['username']),
                        ),
                      );
                    },
                  ),
                  MyImageButton(
                    imageUrl: 'images/pengaturan.png',
                    label: "Pengaturan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pengaturanPage(
                              username: widget.userData['username']),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            MyImageButton(
              imageUrl: 'images/MU.png', // Gantilah dengan gambar logout
              label: "Logout",
              onTap: () async {
                // await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyImageButton extends StatelessWidget {
  final String imageUrl;
  final String label;
  final Function onTap;

  const MyImageButton(
      {required this.imageUrl, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
      ),
      child: Column(children: [
        Image.asset(imageUrl),
        Text(label,
            style: TextStyle(
              color: Colors.black,
            )),
      ]),
    );
  }
}
