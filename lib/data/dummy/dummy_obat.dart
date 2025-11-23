import '../models/obat_model.dart';

class DummyObat {
  static List<ObatModel> dataObat = [
    ObatModel(
      id: "1",
      nama: "Paracetamol",
      kategori: "Analgesik",
      gambar: "assets/obat/paracetamol.png",
      harga: 12000,
    ),
    ObatModel(
      id: "2",
      nama: "Vitamin C 500mg",
      kategori: "Vitamin",
      gambar: "assets/obat/vitamin_c.png",
      harga: 15000,
    ),
    ObatModel(
      id: "3",
      nama: "Betadine",
      kategori: "Antiseptik",
      gambar: "assets/obat/betadine.png",
      harga: 18000,
    ),
    ObatModel(
      id: "4",
      nama: "Amoxicillin",
      kategori: "Antibiotik",
      gambar: "assets/obat/amoxicillin.png",
      harga: 25000,
    ),
    ObatModel(
      id: "5",
      nama: "Minyak Kayu Putih",
      kategori: "Minyak Oles",
      gambar: "assets/obat/kayu_putih.png",
      harga: 16000,
    ),
  ];
}
