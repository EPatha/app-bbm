import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'bbm.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kalkulator BBM",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: kIsWeb
          ? const PhoneFrameWrapper(child: MainHomePage())
          : const MainHomePage(),
    );
  }
}

// Custom Phone Frame Widget
class PhoneFrameWrapper extends StatelessWidget {
  final Widget child;
  
  const PhoneFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50), // Dark blue background
      body: Center(
        child: Container(
          width: 375, // iPhone 13 width
          height: 812, // iPhone 13 height
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Phone screen content
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
              // Notch at the top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 120,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainHomePage();
}

class _MainHomePage extends State<MainHomePage> {
  var listBbm = <BBM>[
    BBM(nama: 'Premium', harga: 10000),
    BBM(nama: 'Pertamax', harga: 14000),
    BBM(nama: 'Pertamax Turbo', harga: 16600),
    BBM(nama: 'Solar', harga: 6800),
  ];

  TextEditingController tujuanCtrl = TextEditingController();
  TextEditingController jarakCtrl = TextEditingController();
  String textHasil = '';
  BBM? selectedBBM;

  _MainHomePage() {
    selectedBBM = listBbm[0];
  }

  void setHasil() {
    if (jarakCtrl.text.isEmpty || int.tryParse(jarakCtrl.text) == null) {
      setState(() {
        textHasil = 'Masukkan jarak tempuh yang valid!';
      });
      return;
    }
    
    // Asumsi: 1 liter untuk 10 km
    double literDibutuhkan = int.parse(jarakCtrl.text) / 10;
    double biaya = selectedBBM!.harga * literDibutuhkan;
    
    setState(() {
      textHasil = 'Liter dibutuhkan: ${literDibutuhkan.toStringAsFixed(1)} L\n'
                  'Biaya BBM: Rp ${biaya.toStringAsFixed(0)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator BBM"),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: const Center(
                  child: Text(
                    '⛽ Hitung BBM & Biaya',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const Text(
                "Nama Tujuan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tujuanCtrl,
                decoration: InputDecoration(
                  hintText: 'Contoh: Jakarta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                "Jarak Tempuh (km)",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: jarakCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 100',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixText: 'km',
                ),
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                "Pilihan BBM",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: DropdownButton<BBM>(
                  isExpanded: true,
                  value: selectedBBM,
                  underline: const SizedBox(),
                  items: listBbm.map((BBM item) {
                    return DropdownMenuItem<BBM>(
                      value: item,
                      child: Text(item.toString()),
                    );
                  }).toList(),
                  onChanged: (BBM? newVal) {
                    setState(() {
                      selectedBBM = newVal;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: setHasil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Hitung BBM",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              if (textHasil.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    textHasil,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
