class Config2 {
  final String _apiDomain = 'phdassistant.com';
  final String _basePath = '/mobile/api';

  Uri apiUri(String path, {Map<String, dynamic>? queryParameters}) {
    return Uri.https(
      _apiDomain,
      '$_basePath$path',
      queryParameters,
    );
  }

  String get mainUrl => apiUri('/').toString();
}
