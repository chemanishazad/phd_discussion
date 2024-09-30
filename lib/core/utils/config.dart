class Config {
  final String _apiDomain = 'www.apacvault.com';
  final String _basePath = 'reimbursement/api';

  Uri apiUri(String path, {Map<String, dynamic>? queryParameters}) {
    return Uri.https(
      _apiDomain,
      '$_basePath$path',
      queryParameters,
    );
  }

  String get mainUrl => apiUri('/').toString();
}
