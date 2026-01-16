# 🍳 Aplikasi Resep Masakan

Aplikasi Resep Masakan adalah aplikasi mobile sederhana berbasis Flutter yang digunakan untuk mengelola data resep masakan. Aplikasi ini dibuat sebagai project mata kuliah Pemrograman Mobile dengan tujuan memahami konsep REST API, penerapan CRUD (Create, Read, Update, Delete), serta penggunaan Apidog sebagai API documentation dan mock server, dan Postman sebagai alat pengujian API sebelum diintegrasikan ke aplikasi mobile.

Aplikasi ini dikembangkan dengan alur perancangan API menggunakan Apidog, pengujian endpoint menggunakan Postman, kemudian integrasi API ke dalam aplikasi Flutter yang menampilkan data resep, detail resep, serta fitur tambah, ubah, dan hapus data.

---

## Teknologi yang Digunakan
- Flutter & Dart  
- Visual Studio Code  
- Apidog (API Documentation & Mock Server)  
- Postman (API Testing)

---

## Arsitektur Sistem
Alur kerja aplikasi dimulai dari pembuatan dan dokumentasi endpoint API di Apidog, kemudian endpoint tersebut diuji menggunakan Postman. Setelah API berjalan dengan baik, aplikasi Flutter mengonsumsi API tersebut untuk menampilkan dan mengelola data resep masakan.


Endpoint yang digunakan:
- GET /recipes : mengambil seluruh data resep  
- GET /recipes/{id} : mengambil detail resep  
- POST /recipes : menambahkan resep  
- PUT /recipes/{id} : memperbarui resep  
- DELETE /recipes/{id} : menghapus resep  

---

## Pengujian API
Pengujian API dilakukan menggunakan Postman dengan membuat sebuah collection bernama **Recipe CRUD** dan sebuah variable bernama `baseUrl` yang berisi alamat mock server Apidog. Seluruh request API menggunakan variable tersebut, contohnya:


---

## Struktur Folder Flutter
Struktur folder aplikasi Flutter disusun agar kode lebih rapi dan terpisah antara tampilan, logika, dan data.


---

## Cara Menjalankan Aplikasi
Pastikan Flutter sudah terinstall, kemudian jalankan perintah berikut di terminal:

```bash
flutter doctor
flutter pub get
flutter run
