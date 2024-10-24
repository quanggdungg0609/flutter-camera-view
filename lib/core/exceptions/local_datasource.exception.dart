// * Exception of Tokens actions
class GetTokensException implements Exception {
  final String message;
  GetTokensException({required this.message});
}

class UpdateTokenException implements Exception {}

class ClearTokensException implements Exception {}

// * Exceptions of Account Info actions
class SaveAccountInfoException implements Exception {}

class GetAccoutInfoException implements Exception {}

class ClearAccountInfoException implements Exception {}

// * Exceptions of User Info actions
class SaveUserInfoException implements Exception {}

class GetUserInfoException implements Exception {}

class ClearUserInfoException implements Exception {}
