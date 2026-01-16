## Cara Run di HP (Android)

### Persiapan
1. Aktifkan **Developer Options**
   - Pengaturan → Tentang Ponsel → klik **Nomor Bentukan/Build Number** 7x
2. Aktifkan **USB Debugging**
   - Pengaturan → Opsi Pengembang → **USB Debugging** ON
3. Sambungkan HP ke laptop menggunakan **kabel data**
4. Saat muncul pop-up di HP pilih **Allow / Izinkan**

### Jalankan Project
Buka terminal di folder project, lalu jalankan:

```bash
flutter pub get
flutter run

## Struktur Folder

Berikut struktur folder utama pada project ini:

lib/
├─ core/ # konfigurasi/konstanta/helper (jika ada)
├─ models/ # model data (class/response)
├─ screens/ # halaman UI (login, home, detail, dll)
├─ services/ # layanan API / database / request (contoh: api_client.dart)
├─ widgets/ # widget kecil reusable (button, card, dll)
└─ main.dart # entry point aplikasi