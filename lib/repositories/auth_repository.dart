class AuthRepository {
  AuthRepository();

  Future<void> signOut() async {
    print("TODO: Handle signOut");
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<bool> isUserAuthenticated() async {
    bool isAuthenticated = false;
    print("TODO: Handle isUserAuthenticated");
    await Future.delayed(const Duration(milliseconds: 500));
    return isAuthenticated;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage = "";

    print("TODO: Handle signInWithEmailAndPassword");
    await Future.delayed(const Duration(seconds: 2));

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signInWithGoogle() async {
    String errorMessage = "";

    print("TODO: Handle signInWithGoogle");
    await Future.delayed(const Duration(seconds: 2));

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signInWithFacebook() async {
    String errorMessage = "";

    print("TODO: Handle signInWithFacebook");
    await Future.delayed(const Duration(seconds: 2));

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password,
      String name, String phone, String countryCode) async {
    String errorMessage = "";

    print("TODO: Handle signUpWithEmailAndPassword");
    await Future.delayed(const Duration(seconds: 2));

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signUpWithGoogle() async {
    String errorMessage = "";

    print("TODO: Handle signUpWithGoogle");
    await Future.delayed(const Duration(seconds: 2));

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signUpWithFacebook() async {
    String errorMessage = "";

    print("TODO: Handle signUpWithFacebook");
    await Future.delayed(const Duration(seconds: 2));

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }
}
