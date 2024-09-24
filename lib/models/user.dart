enum UserRole {
  admin,
  regionalManager,
  branchManager,
  employee,
  technican,
  client,
  noAccess,
  initialRole,
  notAuthenticated
}

enum AuthStatus {
  notAuthenticated,
  authenticatedWithEmailVerified,
  authenticatedWithEmailNotVerified,
  authenticatedWithGoogle,
  authenticatedWithFacebook,
}

class User {
  AuthStatus authStatus;
  UserRole? role;
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;

  User({required this.authStatus});

  static String getRoleName(UserRole role) {
    if (role == UserRole.admin) {
      return "Admin";
    } else if (role == UserRole.regionalManager) {
      return "Regional Manager";
    } else if (role == UserRole.branchManager) {
      return "Branch Manager";
    } else if (role == UserRole.employee) {
      return "Employee";
    } else if (role == UserRole.technican) {
      return "Technican";
    } else if (role == UserRole.client) {
      return "Client";
    }
    return "Undefined";
  }
}
