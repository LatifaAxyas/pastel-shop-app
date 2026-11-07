# 🛍️ Pastel Shop

Aplikasi katalog produk mobile (Flutter) bertema warna pastel dengan fitur **CRUD penuh** (Create, Read, Update, Delete) yang terhubung ke backend [DummyJSON Products](https://dummyjson.com/docs/products).

## 🎥 Video Penjelasan & Demo

**Link YouTube:** _(isi dengan link video kamu, permission Public, wajah terlihat)_

## ✨ Fitur

| Operasi | Fitur di aplikasi | Endpoint backend |
|---------|-------------------|------------------|
| **Read** | Halaman depan menampilkan seluruh produk (grid 2 kolom), halaman detail produk | `GET /products?limit=0` |
| **Read** | Search fungsional (tombol search / enter), tombol ✕ untuk reset | `GET /products/search?q=` |
| **Create** | Tombol **Tambah** (kanan bawah) membuka form tambah produk | `POST /products/add` |
| **Update** | Ikon ✏️ di halaman detail membuka form ubah produk | `PUT /products/{id}` |
| **Delete** | Ikon 🗑️ di halaman detail, dengan dialog konfirmasi | `DELETE /products/{id}` |

Tambahan:
- Validasi form (field wajib, angka, URL gambar).
- State loading, error (tombol coba lagi), hasil kosong, dan pull-to-refresh.
- Notifikasi (snackbar) setelah tambah, ubah, dan hapus.
- Tema warna pastel di seluruh halaman.

> **Catatan backend:** DummyJSON hanya *mensimulasikan* perubahan data. Server membalas sukses untuk POST, PUT, dan DELETE, tetapi tidak benar-benar menyimpannya. Agar hasil CRUD tetap terlihat di aplikasi, respons sukses dari server dicatat di penyimpanan lokal sementara (`ProductService`) dan diterapkan ke daftar produk. Perubahan ini hilang saat aplikasi ditutup total.

## 🎨 Skema Warna Pastel

| Warna | Hex |
|-------|-----|
| Pink | `#FAD4E1` |
| Mint | `#CDF0DD` |
| Sky | `#C6E2FB` |
| Peach | `#FFDCC4` |
| Lavender | `#DDD2F7` |
| Yellow | `#FFF1B8` |
| Background (krem) | `#FFF8F3` |
| Aksen (ungu pastel) | `#B39DDB` |

Palet ada di `lib/theme/app_colors.dart`.

## 🚀 Cara Menjalankan (di handphone)

Prasyarat: [Flutter SDK](https://docs.flutter.dev/get-started/install) terpasang dan HP Android dengan **USB debugging** aktif.

```bash
git clone <link-repo-ini>
cd pastel_shop

# membuat folder android/ios (hanya sekali)
flutter create . --project-name pastel_shop

flutter pub get
flutter devices        # pastikan HP terdeteksi
flutter run            # jalankan di HP
```

> Untuk mode **release** (`flutter run --release` / `flutter build apk`), tambahkan izin internet di
> `android/app/src/main/AndroidManifest.xml` (di atas tag `<application`):
> `<uses-permission android:name="android.permission.INTERNET"/>`

## 📁 Struktur Project

```
lib/
├── main.dart
├── models/product.dart              # model + toJson
├── services/product_service.dart    # CRUD ke backend
├── screens/
│   ├── home_screen.dart             # daftar, search, tombol tambah
│   ├── detail_screen.dart           # detail, ubah, hapus
│   └── product_form_screen.dart     # form tambah / ubah
├── widgets/product_card.dart
└── theme/app_colors.dart
```
