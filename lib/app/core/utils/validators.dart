/// Form validation helpers. Each returns `null` when valid, or an Indonesian
/// error message otherwise. Display text lives here (inline), not in a shared
/// strings file.
class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _phone = RegExp(r'^[0-9+\-\s]{8,15}$');

  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nama lengkap wajib diisi.';
    if (v.length < 3) return 'Nama lengkap minimal 3 karakter.';
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Alamat email wajib diisi.';
    if (!_email.hasMatch(v)) return 'Format email tidak valid.';
    return null;
  }

  static String? password(String? value, {int min = 6}) {
    final v = value ?? '';
    if (v.isEmpty) return 'Kata sandi wajib diisi.';
    if (v.length < min) return 'Kata sandi minimal $min karakter.';
    return null;
  }

  static String? phone(String? value, {bool required = false}) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return required ? 'Nomor telepon wajib diisi.' : null;
    }
    if (!_phone.hasMatch(v)) return 'Nomor telepon tidak valid.';
    return null;
  }
}
