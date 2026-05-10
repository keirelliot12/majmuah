# An-Nibros

Aplikasi Flutter untuk kumpulan amaliyah, wirid, doa, Al-Quran, jadwal shalat,
dan materi KBIHU Nur Multazam.

Project ini berasal dari aplikasi Islamic Flutter, lalu disesuaikan untuk
kebutuhan An-Nibros: tampilan mobile-first, kategori materi lokal, fitur baca
yang lebih nyaman, dan alur offline/download untuk mushaf.

## Status Saat Ini

Checkpoint terakhir ada di:

- `docs/annibros-release-checkpoint.md`
- `docs/release-smoke-test.md`

Ringkasan status:

- Dashboard sudah didesain ulang.
- Pencarian materi sudah diperbaiki.
- Al-Quran tidak lagi diblokir halaman penuh saat mushaf belum diunduh.
- Dzikir & Doa memakai judul Indonesia sebagai tampilan utama.
- Settings sudah dibersihkan dari menu bahasa/RTL dan Github Pengembang.
- Reading screen sudah punya pengaturan baca: ukuran font, pilihan font, dan mode baca gelap.
- KBIHU Nur Multazam sudah masuk menu utama.
- Maulid masih placeholder karena materi belum final.

## Fitur Utama

- Dashboard amaliyah dengan lokasi, kalender Masehi/Hijriyah, jadwal shalat,
  pencarian, terakhir dibaca, menu kategori, dan mutiara hikmah.
- Materi amaliyah dan wirid: Aurad & Doa, Hizib & Ratib, Puji & Bilal,
  Amalan Hijriyah, Maulid, Tahlil & Ziarah, KBIHU, dan Lainnya.
- Al-Quran dengan daftar surah dan download mushaf.
- Dzikir & Doa dengan judul Indonesia dan judul Arab sebagai referensi.
- Jadwal shalat dengan fallback default Gresik, Indonesia.
- Mode gelap/terang.
- Reading settings untuk menyesuaikan pengalaman membaca.
- Download manager untuk aset offline.

## Yang Belum Selesai

- Bitmap icon custom belum final.
- Perlu smoke test Android/emulator.
- Perlu audit lanjutan untuk semua halaman detail bacaan.
- Fallback offline untuk API eksternal perlu diperkuat, terutama jadwal shalat.
- Alur download Quran perlu diuji lengkap: loading, progress, sukses, dan gagal.
- Menu KBIHU perlu diuji satu per satu setelah konten final.

## Menjalankan Project

Gunakan Flutter stable yang kompatibel dengan SDK Dart `>=3.10.3 <4.0.0`.

```powershell
flutter pub get
flutter run -d chrome
```

Untuk Android:

```powershell
flutter pub get
flutter run
```

Untuk build web:

```powershell
flutter build web --no-wasm-dry-run
```

Catatan web lokal:

- `web/index.html` sudah diarahkan memakai CanvasKit lokal.
- Service worker dinonaktifkan untuk menghindari cache lama saat evaluasi desain.
- Jika browser masih menampilkan UI lama, clear site data atau buka dari port/origin baru.

## Verifikasi Rilis

Jalankan minimal:

```powershell
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug
```

Checklist manual ada di:

```text
docs/release-smoke-test.md
```

## Struktur Penting

```text
assets/json/Annibros.json              Data materi utama
assets/json/category.json              Data kategori menu
assets/images/an_nibros_logo.jpg       Logo An-Nibros
lib/presentation/home/                 Dashboard, kategori, Quran, Dzikir, Shalat, Settings
lib/presentation/material/             List dan detail materi bacaan
lib/presentation/search/               Pencarian materi
lib/presentation/settings/             Download manager
docs/                                  Checkpoint dan smoke test release
```

## Catatan Pengembangan

- Fokus desain saat ini adalah tampilan ponsel.
- Jangan mengandalkan screenshot/link upstream lama; README lama sudah tidak
  relevan dengan arah An-Nibros.
- Untuk pekerjaan besar berikutnya, gunakan branch/worktree baru yang bersih.
- Simpan keputusan release dan gap terbaru di `docs/` agar tidak hilang antar sesi.
