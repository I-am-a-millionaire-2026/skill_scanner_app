// Auth Exceptions - These match the logic in FirebaseAuthProvider
class GenericAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
