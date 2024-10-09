class Config {
  final String _apiDomain = 'phddiscussions.in';
  final String _basePath = '/api';

  Uri apiUri(String path, {Map<String, dynamic>? queryParameters}) {
    return Uri.https(
      _apiDomain,
      '$_basePath$path',
      queryParameters,
    );
  }

  String get mainUrl => apiUri('/').toString();
}
