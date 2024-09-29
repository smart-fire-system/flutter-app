

enum AuthStatus {
  notAuthenticated,
  authenticatedWithEmailVerified,
  authenticatedWithEmailNotVerified,
  authenticatedWithGoogle,
  authenticatedWithFacebook,
}

enum UserRole {
  admin,
  regionalManager,
  branchManager,
  employee,
  technican,
  client,
  noRole
}