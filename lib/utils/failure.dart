class Failure {
  final String message;
  final int? code;

  Failure(this.message, {this.code});

  @override
  String toString() {
    return 'Failure(message: $message, code: $code)';
  }
}
