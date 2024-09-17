

class AuthRepository {
  AuthRepository();

  Future<void> signOut() async {
    print("TODO: Handle signOut");
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<bool> isUserAuthenticated() async {
    bool isAuthenticated = false;
    print("TODO: Handle isUserAuthenticated");
    await Future.delayed(const Duration(microseconds: 200));
    return isAuthenticated;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    print("TODO: Handle signInWithEmailAndPassword");
    await Future.delayed(const Duration(seconds: 2));
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
    print("TODO: Handle signInWithFacebook");
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> signUpWithEmailAndPassword(String email, String password,
      String name, String phone, String countryCode) async {
    print("TODO: Handle signUpWithEmailAndPassword");
    print(countryCode);
    await Future.delayed(const Duration(seconds: 2));
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
    print("TODO: Handle signUpWithFacebook");
    await Future.delayed(const Duration(seconds: 2));
  }
}
