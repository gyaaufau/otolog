# OtoLog Case Study

## Ringkasan

**OtoLog** adalah aplikasi mobile berbasis Flutter untuk mencatat kendaraan pribadi, riwayat servis, dan biaya perawatan dalam satu tempat.

Produk ini dirancang sebagai aplikasi **local-first**, sehingga pengguna bisa mengelola data kendaraan tanpa akun dan tanpa ketergantungan ke server. Semua data inti disimpan secara lokal di perangkat, membuat pengalaman penggunaan tetap cepat, sederhana, dan ramah privasi.

Dokumen ini disusun sebagai materi portofolio yang menjelaskan sisi produk, arsitektur teknis, keputusan implementasi, tantangan selama pengembangan, sampai proses rilis ke Google Play.

## Snapshot Proyek

- **Nama produk:** OtoLog
- **Kategori:** Automotive / Productivity
- **Platform utama:** Android
- **Teknologi:** Flutter
- **Versi saat ini:** 1.1.0
- **Arsitektur:** local-first mobile app
- **State management:** Cubit / BLoC
- **Navigasi:** `go_router`
- **Database lokal:** Drift + SQLite
- **Dependency injection:** `get_it`
- **Localization:** Bahasa Indonesia dan English
- **Penyimpanan preferensi:** `SharedPreferences`
- **Status:** sudah dirilis ke Google Play Production

## Latar Belakang Masalah

Riwayat perawatan kendaraan sering tersebar di banyak tempat:

- chat dengan bengkel
- nota fisik
- aplikasi catatan
- ingatan pribadi

Akibatnya, pengguna kesulitan menjawab hal-hal dasar seperti:

- kapan terakhir ganti oli
- berapa total biaya perawatan kendaraan
- servis apa saja yang sudah pernah dilakukan
- pada kilometer berapa suatu komponen diperbaiki

Di sisi lain, banyak aplikasi sejenis terlalu berat, penuh iklan, atau terlalu fokus ke akun dan cloud, padahal banyak pengguna hanya butuh pencatatan personal yang cepat dan jelas.

## Solusi yang Dibangun

OtoLog dibuat untuk menjadi aplikasi pencatatan servis kendaraan yang:

- mudah dipakai
- fokus pada use case personal
- bisa digunakan offline
- menjaga data tetap ada di perangkat

Dengan OtoLog, pengguna bisa:

- menambahkan beberapa kendaraan dalam satu garage
- menyimpan riwayat servis lengkap
- memantau biaya perawatan
- melihat ringkasan aktivitas servis
- mengatur bahasa, satuan jarak, dan mata uang sesuai kebutuhan

## Tujuan Produk

Pengembangan OtoLog diarahkan oleh beberapa tujuan utama:

1. **Pencatatan cepat**
   Menambah kendaraan dan mencatat servis harus terasa ringan.

2. **Offline-first**
   Fitur inti tetap bisa digunakan tanpa internet.

3. **Privasi yang kuat**
   Data pengguna tidak perlu dikirim ke server.

4. **UX yang sederhana**
   Tampilan dan alur aplikasi harus mudah dipahami tanpa terasa rumit.

5. **Setup awal yang jelas**
   Pengguna baru bisa langsung mengatur bahasa, unit, dan currency saat onboarding.

## Fitur Utama

### 1. Manajemen Kendaraan

Pengguna dapat:

- menambah kendaraan
- mengedit data kendaraan
- menghapus kendaraan
- menentukan kendaraan utama
- menambahkan foto kendaraan dari galeri atau kamera

Data kendaraan mencakup:

- nama kendaraan
- nomor plat
- brand dan model
- tahun
- warna
- tipe kendaraan
- VIN
- tanggal pembelian
- odometer
- bahan bakar
- transmisi
- path foto lokal

### 2. Pencatatan Servis

Setiap kendaraan dapat memiliki riwayat servis berisi:

- jenis servis
- tanggal servis
- deskripsi
- biaya
- nama mekanik / bengkel
- catatan tambahan
- odometer saat servis

Ini membuat histori perawatan lebih terstruktur dibanding catatan bebas biasa.

### 3. Dashboard dan Statistik

Aplikasi menyediakan ringkasan seperti:

- jumlah kendaraan
- jumlah servis
- total biaya servis
- aktivitas perawatan
- statistik servis per kendaraan

Pendekatannya sengaja dibuat praktis, bukan analitik yang terlalu kompleks.

### 4. Onboarding dan Preferensi Awal

Flow onboarding membantu pengguna baru untuk:

- mengenal fungsi aplikasi
- memilih bahasa
- memilih satuan jarak
- memilih currency

Alur ini dibuat agar pengalaman first-run terasa lebih matang dan tidak membingungkan.

### 5. Localization

OtoLog mendukung dua bahasa:

- Bahasa Indonesia
- English

Localization diterapkan ke berbagai area penting seperti onboarding, settings, navigasi, dan legal copy.

### 6. Branding dan Kesiapan Rilis

Di luar fitur inti, proyek ini juga mencakup:

- logo baru yang selaras dengan tema aplikasi
- app icon baru
- native splash screen
- aset store listing untuk Play Console

Ini penting karena target proyeknya bukan sekadar prototype, tapi produk yang terasa siap rilis.

## Arah User Experience

Desain OtoLog diarahkan agar terasa:

- bersih
- konsisten
- mudah dipahami
- tidak berlebihan

Prinsip UX yang dipakai antara lain:

- struktur section yang jelas
- form yang ringkas
- empty state yang informatif
- konsistensi visual antara onboarding dan settings
- interaksi yang terasa halus saat user memilih opsi

Beberapa perbaikan UX yang sempat dikerjakan:

- menyederhanakan onboarding menjadi flow yang lebih fokus
- menyamakan visual selector di onboarding dengan komponen settings
- mengganti pemilihan currency ke modal bottom sheet agar konsisten
- menghaluskan animasi selected state pada chip

## Stack Teknologi

### Teknologi utama

- `Flutter`
- `flutter_bloc`
- `go_router`
- `get_it`
- `drift`
- `sqlite3_flutter_libs`
- `shared_preferences`
- `image_picker`
- `fl_chart`
- `url_launcher`
- `flutter_native_splash`

### Alasan pemilihan

- **Flutter** mempermudah pengembangan mobile dengan satu codebase.
- **Cubit / BLoC** membantu menjaga state tetap terstruktur.
- **Drift** memberi akses database yang typed dan mendukung migrasi schema.
- **get_it** membuat dependency wiring tetap sederhana.
- **go_router** cocok untuk struktur aplikasi bertab dan route detail.
- **SharedPreferences** cukup untuk menyimpan preferensi kecil dan status onboarding.

## Arsitektur Aplikasi

Secara umum, OtoLog dibagi ke empat lapisan utama:

- **Presentation layer**
  Berisi screen dan widget
- **State layer**
  Berisi cubit dan state
- **Data layer**
  Berisi database dan service / repository
- **Infrastructure layer**
  Berisi theme, localization, router, dan dependency injection

### Startup flow

Saat aplikasi dijalankan, alurnya adalah:

1. inisialisasi Flutter bindings
2. inisialisasi service locator
3. membaca status onboarding
4. menentukan route awal
5. membangun aplikasi dengan provider state yang dibutuhkan

File inti yang terlibat:

- `/lib/main.dart`
- `/lib/router.dart`
- `/lib/shared/core/service_locator.dart`
- `/lib/repositories/onboarding_repository.dart`

### State management

Beberapa Cubit utama yang dipakai:

- `VehicleCubit`
- `VehicleListCubit`
- `VehicleDetailCubit`
- `ServiceVehicleSelectorCubit`
- `LanguageCubit`
- `UnitCubit`
- `CurrencyCubit`

Pendekatan ini menjaga tiap state tetap fokus pada use case tertentu.

### Navigasi

Navigasi utama menggunakan `go_router` dengan shell route untuk tab:

- Home
- Garage
- Service Logs
- Settings

Di atas itu ada route detail untuk:

- detail kendaraan
- add / edit kendaraan
- add / edit servis
- detail servis
- statistik servis

## Data Layer

OtoLog menggunakan Drift di atas SQLite sebagai local database.

### Tabel utama

#### `vehicles`

Menyimpan data kendaraan seperti:

- identitas kendaraan
- metadata kendaraan
- odometer
- path foto lokal
- status kendaraan utama
- timestamp

#### `service_records`

Menyimpan data servis seperti:

- relasi ke kendaraan
- jenis servis
- tanggal
- biaya
- mekanik
- catatan
- odometer
- timestamp

### Migrasi schema

Database disiapkan dengan migrasi schema agar perubahan versi aplikasi tidak merusak data lama. Ini penting saat aplikasi sudah masuk fase release dan pengguna melakukan update.

## Localization dan Preferensi

Localization diintegrasikan ke startup app dan settings.

Preferensi yang bisa disimpan:

- bahasa
- satuan jarak
- currency
- status onboarding selesai

Pendekatan ini membuat pengalaman pengguna lebih personal sejak awal penggunaan.

## Privasi dan Pengelolaan Data

Salah satu keputusan paling penting di OtoLog adalah pendekatan **local-first**.

### Prinsip privasi

- tidak memerlukan akun
- tidak memakai analytics pihak ketiga
- tidak menggunakan ad tracking
- data kendaraan dan servis tetap di perangkat
- preferensi pengguna disimpan secara lokal

### Penanganan foto

Pengguna bisa memilih foto kendaraan dari galeri atau kamera. Namun fitur ini hanya untuk pemilihan foto yang dipicu langsung oleh user, bukan untuk akses media yang luas.

Saat persiapan rilis, permission Android untuk media diperbaiki agar sesuai kebijakan Google Play dan tidak meminta akses yang tidak diperlukan.

## Tantangan Nyata yang Diselesaikan

Bagian ini penting untuk portofolio karena menunjukkan proses problem solving nyata saat aplikasi mendekati rilis.

### 1. Bug add vehicle saat data kosong

**Masalah:**  
Saat aplikasi masih kosong lalu user menambahkan kendaraan pertama, layar daftar kendaraan bisa terlihat stuck.

**Penyebab:**  
State sukses operasi tidak lagi dianggap sebagai state yang bisa dirender oleh screen list.

**Solusi:**  
State sukses operasi diubah agar tetap membawa data loaded, sehingga snackbar sukses tetap muncul tanpa membuat UI kehilangan konten.

### 2. Bug default vehicle pada add service

**Masalah:**  
Di form add service umum, kendaraan pertama bisa terlihat terpilih secara visual tetapi ID kendaraan sebenarnya belum terset.

**Dampak:**  
User merasa sudah memilih kendaraan, tetapi validasi save tetap gagal.

**Solusi:**  
Sinkronisasi antara selected state visual dan selected vehicle ID diperbaiki.

### 3. Save service terlalu cepat pop screen

**Masalah:**  
Add/edit service sebelumnya langsung menutup screen sebelum proses simpan benar-benar selesai.

**Dampak:**  
Jika terjadi error saat menyimpan, user bisa kehilangan konteks dan gagal melihat masalahnya.

**Solusi:**  
Flow save diubah agar menunggu hasil operasi selesai, meng-handle error, refresh state terkait, lalu baru kembali ke screen sebelumnya.

### 4. Compliance issue Google Play untuk media permission

**Masalah:**  
Release sempat ditandai karena mendeklarasikan permission media yang terlalu luas untuk use case yang hanya memilih foto kendaraan sesekali.

**Solusi:**  
Permission broad media dihapus dari manifest Android, lalu release dibuild ulang dengan version code baru.

**Nilai portofolio:**  
Ini menunjukkan kemampuan menangani isu kebijakan platform, bukan hanya implementasi fitur.

## Proses QA dan Release

Pengembangan OtoLog tidak berhenti di coding fitur. Proyek ini juga melewati proses QA dan release yang lebih realistis.

### Aktivitas sebelum rilis

- merapikan onboarding
- memperbarui app icon dan splash
- menyiapkan store listing
- memperbarui privacy policy
- menambahkan terms of service
- memasang rate app link
- membangun APK dan AAB release
- memperbaiki issue policy Google Play

### Fokus pengujian

Beberapa flow yang diprioritaskan untuk QC:

- first launch
- onboarding
- add first vehicle dari empty state
- add / edit / delete service
- perubahan bahasa, unit, dan currency
- persistence setelah app restart
- tampilan app icon, splash, dan routing di build release

### Mindset produksi

OtoLog diperlakukan seperti produk yang benar-benar akan dipakai user, sehingga aspek berikut juga diperhatikan:

- versioning
- version code
- release note
- open testing
- production rollout
- legal copy
- store metadata

## Branding dan Presentasi Produk

Selain coding fitur, proyek ini juga mencakup aspek identitas visual:

- pembuatan logo baru yang lebih sesuai tema aplikasi
- penyesuaian app icon agar lebih kuat di launcher
- native splash screen dengan identitas visual baru
- aset store listing untuk Play Console

Ini memperkuat posisi proyek sebagai produk utuh, bukan sekadar demo teknis.

## Nilai yang Ditunjukkan Proyek Ini

Dari sudut pandang portofolio, OtoLog menunjukkan kemampuan untuk:

- merancang dan mengembangkan aplikasi mobile end-to-end
- membangun aplikasi Flutter local-first
- mengelola state secara terstruktur
- memakai database lokal dengan migrasi schema
- menerapkan localization dan preference management
- mengerjakan polish UX pada onboarding dan settings
- menangani bug release-critical
- menyelesaikan isu compliance Google Play
- menyiapkan aset branding dan store listing

## Pengembangan Selanjutnya

Beberapa peluang pengembangan berikutnya:

- reminder servis berkala
- backup dan restore data
- export data
- cloud sync opsional
- statistik yang lebih kaya
- saran interval servis
- test coverage yang lebih luas
- penambahan bahasa lain

## Aset Portofolio yang Disarankan

Untuk memperkuat dokumentasi ini, akan sangat bagus jika dilengkapi dengan:

1. screenshot onboarding
2. screenshot garage list
3. screenshot detail kendaraan
4. screenshot add service
5. screenshot service logs
6. screenshot statistik
7. screenshot settings
8. visual icon, logo, dan splash

## Narasi Portofolio yang Direkomendasikan

Narasi yang kuat untuk membingkai proyek ini di portofolio:

> Saya membangun OtoLog sebagai aplikasi pencatatan servis kendaraan yang local-first, fokus pada privasi, dan mudah dipakai sehari-hari. Selain mengembangkan fitur inti dengan Flutter, saya juga menangani onboarding, localization, database lokal, branding, store listing, proses release, serta issue compliance Google Play menjelang publikasi produksi.

## File Teknis Penting

Beberapa file yang relevan untuk pembaca teknis:

- `/lib/main.dart`
- `/lib/router.dart`
- `/lib/shared/core/service_locator.dart`
- `/lib/database/database.dart`
- `/lib/screens/onboarding/onboarding_screen.dart`
- `/lib/screens/garage/vehicles_screen.dart`
- `/lib/screens/garage/vehicle_detail_screen.dart`
- `/lib/screens/logs/add_service_screen.dart`
- `/lib/screens/logs/service_logs_screen.dart`
- `/lib/screens/settings/settings_screen.dart`

## Pengembangan Dokumentasi Berikutnya

Dokumen ini bisa dikembangkan lagi menjadi:

- `README.md` proyek yang lebih profesional
- halaman studi kasus di website portofolio
- artikel blog teknis / product build log
- dokumen internal product recap

Tambahan yang akan sangat membantu di iterasi berikutnya:

- screenshot final
- diagram arsitektur
- diagram database
- before / after design comparison
- lessons learned
- catatan keputusan produk
