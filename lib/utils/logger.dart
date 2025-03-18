class Logger {
  static void success(String message) {
    print('\x1B[32m✅ $message\x1B[0m'); // Green
  }

  static void error(String message) {
    print('\x1B[31m❌ $message\x1B[0m'); // Red
  }

  static void warning(String message) {
    print('\x1B[33m⚠️ $message\x1B[0m'); // Yellow
  }

  static void info(String message) {
    print('\x1B[34mℹ️   $message\x1B[0m'); // Blue
  }
}
