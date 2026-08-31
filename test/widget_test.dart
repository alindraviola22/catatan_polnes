import 'package:flutter_test/flutter_test.dart';
import 'package:catatan_polnes/domain/entity/catatan.dart';
import 'package:catatan_polnes/data/repository/catatan_repository_memori.dart';

void main() {
  group('Pengujian Entitas Catatan (Domain Layer)', () {
    test('1. Catatan baru menyimpan judul dengan benar', () {
      final c = Catatan.baru(judul: 'Tugas Kuliah', isi: 'Bikin laporan');
      expect(c.judul, 'Tugas Kuliah');
    });

    test('2. Catatan baru menyimpan isi dengan benar', () {
      final c = Catatan.baru(judul: 'Tugas Kuliah', isi: 'Bikin laporan');
      expect(c.isi, 'Bikin laporan');
    });

    test('3. ID otomatis di-generate dan tidak kosong', () {
      final c = Catatan.baru(judul: 'A', isi: 'B');
      expect(c.id.isNotEmpty, true);
    });

    test('4. judulValid bernilai true jika judul diisi dengan teks', () {
      final c = Catatan.baru(judul: 'Ada Judulnya', isi: 'B');
      expect(c.judulValid, true);
    });

    test('5. judulValid bernilai false jika judul dikosongkan', () {
      final c = Catatan.baru(judul: '', isi: 'B');
      expect(c.judulValid, false);
    });
  });

  group('Pengujian Repository Memori (Data Layer)', () {
    test('6. Saat awal dipanggil, daftar catatan harus kosong', () {
      final repo = CatatanRepositoryMemori();
      expect(repo.ambilSemua().isEmpty, true);
    });

    test('7. Fungsi tambah() berhasil memasukkan satu catatan ke memori', () {
      final repo = CatatanRepositoryMemori();
      repo.tambah(Catatan.baru(judul: 'X', isi: 'Y'));
      expect(repo.ambilSemua().length, 1);
    });

    test('8. Catatan yang ditambahkan ke repository datanya tetap utuh', () {
      final repo = CatatanRepositoryMemori();
      repo.tambah(Catatan.baru(judul: 'Catatan Penting', isi: 'Y'));
      expect(repo.ambilSemua().first.judul, 'Catatan Penting');
    });

    test('9. Fungsi hapus() berhasil membuang catatan berdasarkan ID', () {
      final repo = CatatanRepositoryMemori();
      final c = Catatan.baru(judul: 'X', isi: 'Y');
      repo.tambah(c);

      repo.hapus(c.id); // Proses hapus
      expect(repo.ambilSemua().isEmpty, true);
    });

    test('10. Fungsi hapus() dengan ID yang salah tidak merusak data lain', () {
      final repo = CatatanRepositoryMemori();
      repo.tambah(Catatan.baru(judul: 'X', isi: 'Y'));

      repo.hapus('id_ngawur_yang_tidak_ada');
      expect(repo.ambilSemua().length, 1); // Datanya harus tetap ada 1
    });
  });
}
