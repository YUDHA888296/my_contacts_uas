import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db/database_helper.dart';
import '../models/contact.dart';
import 'form_screen.dart';

class DetailScreen extends StatelessWidget {
  final Contact contact;

  const DetailScreen({super.key, required this.contact});

  // Fitur Inovatif: WhatsApp
  void _launchWhatsApp(BuildContext context) async {
    String phone = contact.phone.replaceAll(
      RegExp(r'\D'),
      '',
    ); // Hapus non-digit

    // Ganti 08xxx jadi 628xxx
    if (phone.startsWith('0')) {
      phone = '62${phone.substring(1)}';
    }

    final url = Uri.parse("https://wa.me/$phone");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak bisa membuka WhatsApp';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal membuka WhatsApp/Tidak terinstall"),
        ),
      );
    }
  }

  // Fitur Inovatif: Telepon
  void _launchCall(BuildContext context) async {
    final url = Uri.parse("tel:${contact.phone}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal melakukan panggilan")),
      );
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kontak?"),
        content: Text("Apakah Anda yakin ingin menghapus ${contact.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.delete(contact.id!);
              if (context.mounted) {
                Navigator.pop(context); // Tutup Dialog
                Navigator.pop(context); // Kembali ke Home
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kontak"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FormScreen(contact: contact),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              contact.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildDetailItem(Icons.phone, "Nomor HP", contact.phone),
            _buildDetailItem(Icons.email, "Email", contact.email),
            const SizedBox(height: 40),

            // Tombol Fitur Inovatif
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _launchWhatsApp(context),
                  icon: const Icon(Icons.chat),
                  label: const Text("WhatsApp"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launchCall(context),
                  icon: const Icon(Icons.call),
                  label: const Text("Telepon"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
