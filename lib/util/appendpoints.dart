class AppEndPoints {
  static const String baseUrl = "https://ef6d-41-210-146-19.ngrok-free.app";
  //auth endpoints
  static const String loginEndPoint = "/auth/login";
  // static const String logoutEndPoint = "/logout";
  static const String registerEndPoint = "/auth/register";
  static const String getUsersEndPoint = "/auth/users";
  static const String getIncomeList = "/features/income";
  static const String getExpenseList = "/features/expenses";
  static const String addIncome = "/features/add_income";
  static const String addExpense = "/features/add_expense";

  static const String getIncomeAnalytics = "/features/income_analytics";
}
