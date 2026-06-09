# SOP-ify

Aplikasi mobile berbasis AI untuk membantu **UMKM Indonesia** menyusun
**Standard Operating Procedure (SOP)** secara otomatis. Pengguna cukup
menuliskan atau **merekam** prosedur usahanya dengan bahasa sehari-hari, lalu
AI akan merapikannya menjadi SOP yang terstruktur dan siap pakai.

> Proyek Capstone **PJK-GM069** — kolaborasi **Pijak × IBM SkillsBuild**.

---

## ✨ Fitur Utama

- **Autentikasi** — daftar, masuk, dan kelola sesi pengguna.
- **Buat SOP dari Teks** — tulis prosedur, AI menyusunnya menjadi langkah-langkah.
- **Buat SOP dari Suara** — rekam suara → transkripsi otomatis (Speech-to-Text)
  → tinjau/edit transkrip → generate SOP.
- **Riwayat SOP** — daftar SOP tersimpan, pencarian, dan pengelompokan per waktu.
- **Bagikan SOP** — kirim hasil SOP via WhatsApp atau aplikasi lain.
- **Profil & Edit Profil** — kelola data akun pengguna.
- **11 Bidang Usaha UMKM** — F&B, Retail, Konveksi, Industri Kreatif,
  Pendidikan, Jasa Teknik, Jasa Perawatan, Agribisnis, Otomotif, Properti,
  dan Kesehatan.

---

## 🧱 Arsitektur & Tech Stack

**Frontend (repositori ini)**

- **Flutter** (fokus platform **Android**) dengan arsitektur **GetX**
  (state management, dependency injection, routing).
- **flutter_screenutil** — desain responsif (design size 393×852).
- **google_fonts** — tipografi.
- **dio** + **pretty_dio_logger** — HTTP client & logging.
- **flutter_dotenv** — konfigurasi base URL backend lewat `.env`.
- **flutter_secure_storage** — menyimpan token autentikasi secara aman
  (Android Keystore / iOS Keychain).
- **get_storage** — menyimpan data profil pengguna (non-sensitif).
- **record** + **path_provider** — perekaman audio untuk fitur suara.
- **permission_handler** — pengelolaan izin mikrofon.
- **connectivity_plus** — deteksi status koneksi internet.
- **shimmer** — placeholder animasi saat memuat data.
- **share_plus** + **url_launcher** — berbagi SOP & membuka WhatsApp.

**Backend (repositori terpisah)**

- **FastAPI** (Python) di-deploy pada **Google Cloud Run**.
- **MongoDB Atlas** sebagai basis data.
- **AI generasi SOP**: model **Gemma 2B** yang di-*fine-tune* dengan **LoRA**.
- **Speech-to-Text**: **Whisper / faster-whisper**.

---

## 📂 Struktur Proyek

```
lib/
├── main.dart                  # Entry point: dotenv, GetStorage, DI, runApp
└── app/
    ├── core/
    │   ├── constants/         # Konstanta (mis. kategori SOP)
    │   ├── network/           # ApiClient (Dio) + ApiException
    │   ├── theme/             # Warna, spacing, text styles, tema
    │   ├── utils/             # Dialog, share, dialog tersimpan, dll.
    │   └── values/            # String & aset statis
    ├── data/
    │   ├── models/            # Model data (UserModel, SopModel, dst.)
    │   ├── repositories/      # Auth/User/SOP repository
    │   └── services/          # AuthService, ConnectivityService
    ├── modules/               # Fitur per layar (GetX module)
    │   ├── splash/ · login/ · register/
    │   ├── home/ · riwayat/ · profil/ · edit_profile/
    │   ├── botnavbar/
    │   ├── sop_create/        # Buat SOP dari teks
    │   └── sop_create_voice/  # Buat SOP dari suara
    ├── routes/                # Definisi route & binding
    └── widgets/               # Widget reusable (SopCard, shimmer, dll.)
```

---

## 🔧 Konfigurasi

1. **Environment** — salin `.env.example` menjadi `.env`, lalu isi base URL backend:

   ```env
   API_BASE_URL=https://backend-api-464880705922.asia-southeast1.run.app
   ```

   `.env` sudah terdaftar di `pubspec.yaml` (bagian `assets`) dan di-`.gitignore`
   (tidak ikut ter-commit). Jika `.env` tidak ada, aplikasi memakai URL default
   bawaan (`ApiClient.baseUrl`).

2. **Izin** sudah dideklarasikan:
   - Android (`AndroidManifest.xml`): `INTERNET`, `RECORD_AUDIO`.
   - iOS (`Info.plist`): `NSMicrophoneUsageDescription`.
   - `minSdk` Android = **23** (disyaratkan oleh `record`/`permission_handler`).

---

## ▶️ Menjalankan Aplikasi

```bash
flutter pub get
dart run flutter_launcher_icons   # generate ikon aplikasi (sekali / saat ikon berubah)
flutter run                       # jalankan di device/emulator Android
```

Build APK rilis:

```bash
flutter build apk --release
```

---

## 🎨 Ikon Aplikasi

Ikon dihasilkan oleh **flutter_launcher_icons** dari `assets/icon/app_icon.png`
(dan `app_icon_foreground.png` untuk adaptive icon Android). Untuk mengganti
ikon: timpa file tersebut (disarankan ukuran **1024×1024**), lalu jalankan
`dart run flutter_launcher_icons`.

---

## 👥 Tim

Proyek Capstone **PJK-GM069** (Pijak × IBM SkillsBuild). Pengembangan mobile
(Flutter) oleh **Favian**, bersama tim untuk backend & machine learning.
