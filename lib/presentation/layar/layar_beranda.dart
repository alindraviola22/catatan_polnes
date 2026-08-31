import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/daftar_catatan_notifier.dart';

class LayarBeranda extends ConsumerWidget {
  const LayarBeranda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catatan = ref.watch(daftarCatatanProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catatan POLNES')),
      body: catatan.isEmpty
          ? const Center(child: Text('Belum ada catatan'))
          : ListView.builder(
              itemCount: catatan.length,
              itemBuilder: (context, i) {
                final item = catatan[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(item.judul),
                    subtitle: Text(
                      item.isi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => context.pushNamed(
                      'detailCatatan',
                      pathParameters: {'id': item.id},
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Simpan sementara untuk fitur urungkan (undo)
                        final itemDihapus = item;

                        // Hapus catatan dari state
                        ref.read(daftarCatatanProvider.notifier).hapus(item.id);

                        // Tampilkan Snackbar dengan tombol Undo (Urungkan)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Catatan "${itemDihapus.judul}" dihapus',
                            ),
                            action: SnackBarAction(
                              label: 'URUNGKAN',
                              onPressed: () {
                                // Kembalikan catatan jika tombol urungkan ditekan
                                ref
                                    .read(daftarCatatanProvider.notifier)
                                    .tambah(itemDihapus.judul, itemDihapus.isi);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormTambah(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Fungsi untuk memunculkan formulir tambah catatan dengan validasi
  void _tampilkanFormTambah(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final judulController = TextEditingController();
    final isiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Catatan Baru'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul Catatan'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: isiController,
                decoration: const InputDecoration(labelText: 'Isi Catatan'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi tidak boleh kosong!';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Jika validasi lolos, panggil fungsi tambah
                ref
                    .read(daftarCatatanProvider.notifier)
                    .tambah(judulController.text, isiController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
