class BBM {
  String nama;
  int harga;

  BBM({required this.nama, required this.harga});

  @override
  String toString() {
    return this.nama + " : " + this.harga.toString();
  }
}
