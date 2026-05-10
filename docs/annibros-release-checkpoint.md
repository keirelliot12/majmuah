# Annibros Release Checkpoint

Tanggal: 2026-05-09
Branch: `codex/annibros-release-fixes`
Worktree: `C:\tmp\majmuah-master-audit`

## Sudah Dikerjakan

- Dashboard didesain ulang dengan header lokasi, tanggal Masehi/Hijriyah, kartu jadwal shalat, pencarian, terakhir dibaca, grid menu, dan kartu mutiara hikmah.
- Navigasi bawah dan menu utama dirapikan, termasuk KBIHU Nur Multazam, Maulid placeholder, dan penghapusan fitur yang tidak dipakai.
- Kategori materi disesuaikan dari revisi Excel dan konten KBIHU mulai diadakan.
- Keputusan terbaru: Khutbah perlu dikembalikan sebagai konten dinamis/API-backed; Mutiara Hikmah juga akan API-backed. Konten bacaan lainnya tetap statis dari bundle JSON.
- Pencarian diperbaiki agar bisa menampilkan hasil dan detail materi.
- Bacaan materi dirapikan: paragraf lebih jelas, tombol salin di bacaan dihapus, dan reading settings ditambahkan.
- Al-Quran tidak lagi diblokir halaman penuh saat mushaf belum diunduh; daftar surah tetap terlihat dan download muncul sebagai popup.
- Dzikir & Doa menampilkan judul Indonesia sebagai judul utama, dengan judul Arab tetap disimpan sebagai subtitle.
- Jadwal shalat memakai fallback lokasi Gresik dan menyediakan tombol Update Lokasi.
- Pengaturan dibersihkan: menu bahasa/RTL dan Github Pengembang dihapus, logo Annibros dipakai, dan mode gelap/terang difungsikan.
- Web bootstrap diarahkan ke CanvasKit lokal dan service worker dinonaktifkan untuk mencegah cache lama saat evaluasi desain lokal.

## Belum Selesai

- Bitmap icon custom belum digenerate final; icon sekarang masih berbasis komponen/ikon sementara.
- API eksternal masih gagal di lingkungan offline/restricted network, terutama jadwal shalat Aladhan dan beberapa endpoint dummy lama.
- Perlu audit ulang layar detail bacaan setelah desain utama stabil.
- Perlu cleanup repo asli `C:\Users\COMPUTER\Documents\GitHub\majmuah` karena sempat tercampur perubahan; fokus kerja saat ini tetap di worktree.
- Perlu smoke test Android Studio/emulator setelah web flow stabil.
- Khutbah belum dikembalikan ke navigasi aktif dan belum tersambung API.
- Mutiara Hikmah masih statis di dashboard; belum tersambung API/cache.

## Plan Lanjutan

- `docs/superpowers/plans/2026-05-10-annibros-release-backlog-plan.md`

## Verifikasi Terakhir

- Server worktree: `http://127.0.0.1:8794/`
- Bundle worktree memuat string baru: `Download Nanti`, `Update Lokasi`, `Dzikir Pagi`, `KBIHU`.
- Bundle worktree tidak memuat lagi string lama: `Ganti Bahasa - Language`, `Github Pengembang`.
- Screenshot browser pada origin bersih `127.0.0.1:8794` menunjukkan:
  - Quran menampilkan popup download, bukan halaman blok penuh.
  - Dzikir menampilkan judul Indonesia.
  - Settings tidak menampilkan menu bahasa dan developer.

## Catatan Risiko

- `flutter build web --no-wasm-dry-run` sempat timeout, tetapi `build/web/main.dart.js` berhasil diperbarui dan diverifikasi secara visual.
- Jangan gunakan `localhost:8792` untuk evaluasi karena service worker/cache lama pernah mengunci tampilan. Gunakan `127.0.0.1:8794`.
