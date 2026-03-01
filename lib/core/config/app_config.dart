/// Central place for all environment / runtime configuration.
/// Change [apiBaseUrl] whenever the backend URL changes (e.g. ngrok restart).
class AppConfig {
  AppConfig._();

  /// Backend base URL — includes the /api prefix.
  static const String apiBaseUrl =
      'https://unprying-numerally-simone.ngrok-free.dev/api';

  /// Convenience getter for the auth sub-path.
  static const String authUrl = '$apiBaseUrl/auth';
}
