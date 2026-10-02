// ignore_for_file: constant_identifier_names

/// Endpoint paths, **relative** to `ApiClient`'s base URL.
///
/// The host is read from `--dart-define=API_BASE_URL=...` (see [baseUrl])
/// and applied via Dio's `BaseOptions`, so pointing the app at another
/// backend never touches this file.
class ApiRoutes {
  const ApiRoutes._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.financeapp.dev/api/v1',
  );

  //*========================================== auth ==========================================*/

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  //*========================================== accounts ==========================================*/

  static const String accounts = '/accounts';
  static String accountById(String id) => '/accounts/$id';

  //*========================================== transactions ==========================================*/

  static const String transactions = '/transactions';
  static String transactionById(String id) => '/transactions/$id';

  //*========================================== budgets ==========================================*/

  static const String budgets = '/budgets';
  static String budgetById(String id) => '/budgets/$id';

  //*========================================== analytics ==========================================*/

  static const String analyticsSummary = '/analytics/summary';
  static const String analyticsTrends = '/analytics/trends';

  //*========================================== dashboard ==========================================*/

  static const String dashboardOverview = '/dashboard/overview';

  //*========================================== settings ==========================================*/

  static const String settings = '/settings';
  static const String profile = '/settings/profile';
}
