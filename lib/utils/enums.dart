enum AuthStatus {
  notAuthenticated,
  authenticated,
  authenticatedNotVerified,
}

enum UserRole {
  masterAdmin,
  admin,
  companyManager,
  branchManager,
  employee,
  client
}

enum AppScreen {
  viewBranches,
  viewBranchDetails,
  editBranches,
  addBranhes,
  viewCompanies,
  viewCompanyDetails,
  editCompanies,
  addCompanies,
}
