class Validators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username wajib diisi";
    }
    if (value.length < 4) {
      return "Username minimal 4 karakter";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password wajib diisi";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email wajib diisi";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Format email tidak valid";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Nomor telepon wajib diisi";
    }
    if (value.length < 10) {
      return "Nomor telepon tidak valid";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Nomor telepon hanya boleh angka";
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Nama Lengkap wajib diisi";
    }
    return null;
  }

  static String? validateAlamat(String? value) {
    if (value == null || value.isEmpty) {
      return "Alamat wajib diisi";
    }
    return null;
  }
}
