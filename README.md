# 🛍️ Pastel Shop

Aplikasi katalog produk mobile (Flutter) bertema warna pastel. Data produk diambil dari API [DummyJSON Products](https://dummyjson.com/docs/products).

## 🎥 Video Penjelasan & Demo

**Link YouTube:** (https://youtu.be/O4bgisvq8Pk)

## ✨ Fitur

- **Halaman depan**: menampilkan seluruh produk (194 item) dalam grid 2 kolom dengan kartu berwarna pastel.
- **Halaman detail produk**: galeri gambar (geser), kategori, brand, rating, harga + diskon, deskripsi, stok, pengiriman, garansi, kebijakan retur, dan ulasan. Dibuka dengan menekan produk di halaman depan.
- **Search fungsional**: ketik kata kunci lalu tekan tombol search (atau enter di keyboard). Mencari ke endpoint `/products/search`. Ada tombol ✕ untuk menghapus pencarian.
- State loading, error (dengan tombol coba lagi), dan hasil kosong.
- Pull-to-refresh di halaman depan.

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

## 🔌 API yang Dipakai

- `GET https://dummyjson.com/products?limit=0` — semua produk
- `GET https://dummyjson.com/products/search?q=<kata>&limit=0` — pencarian

## 🚀 Cara Menjalankan (di handphone)

Prasyarat: [Flutter SDK](https://docs.flutter.dev/get-started/install) terpasang dan HP Android dengan **USB debugging** aktif (atau emulator Android).

```bash
git clone <link-repo-ini>
cd pastel_shop

# membuat folder android/ios (hanya sekali)
flutter create . --project-name pastel_shop

flutter pub get
flutter devices        # pastikan HP terdeteksi
flutter run            # jalankan di HP
```

> Jika aplikasi dibuild **release** (`flutter build apk`), pastikan izin internet ada di
> `android/app/src/main/AndroidManifest.xml`:
> `<uses-permission android:name="android.permission.INTERNET"/>`

## 📁 Struktur Project

```
lib/
├── main.dart
├── models/product.dart
├── services/product_service.dart
├── screens/
│   ├── home_screen.dart
│   └── detail_screen.dart
├── widgets/product_card.dart
└── theme/app_colors.dart
```
