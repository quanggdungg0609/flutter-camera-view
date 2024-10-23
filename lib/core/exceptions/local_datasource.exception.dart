class FailedToGetTokens implements Exception {
  final String message;
  FailedToGetTokens({required this.message});
}

class FailedToUpdateToken implements Exception {}

class FailedToClearTokens implements Exception {}
