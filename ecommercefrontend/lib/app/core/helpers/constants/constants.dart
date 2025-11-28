class Constants {
  Constants._();

  // Environment Keys
  static const ENV_BASE_URL = 'base_url';
  static const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN_KEY';
  static const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN_KEY';

  // Environment Default Values
  static const ENV_DEFAULT_API_URL = 'http://localhost:3000';

  // Route Paths
  static const ROUTE_LOGIN = '/login';
  static const ROUTE_REGISTER = '/register';
  static const ROUTE_HOME = '/';
  static const ROUTE_CHECKOUT = '/checkout';
  static const ROUTE_SETTINGS = '/settings';
  static const ROUTE_PRODUCT_DETAILS = '/product/:id';

  // Route Names
  static const ROUTE_NAME_PRODUCT_DETAILS = 'productDetails';

  // API Endpoints - Auth
  static const API_AUTH_LOGIN = '/auth/login';
  static const API_AUTH_REFRESH = '/auth/refresh';
  static const API_AUTH_REGISTER = '/auth/register';
  static const API_AUTH_WHITELABEL = '/auth/whitelabel';

  // API Endpoints - Users
  static const API_USERS_ME = '/users/me';
  static const API_USERS_PROFILE_PHOTO = '/users/me/profile-photo';

  // API Endpoints - Products
  static const API_PRODUCTS = '/products';
  static const API_PRODUCTS_SYNC = '/products/sync';

  // API Endpoints - Clients
  static const API_CLIENTS = '/clients';

  // Helper methods for dynamic URLs
  static String getClientEndpoint(String clientId) => '/clients/$clientId';
  static String getClientSettingsEndpoint(String clientId) =>
      '/clients/$clientId/settings';
  static String getClientLogoEndpoint(String clientId) =>
      '/clients/$clientId/logo';
  static String getClientBannerImagesEndpoint(String clientId) =>
      '/clients/$clientId/banner-images';
  static String getWhitelabelEndpoint(String baseUrl) =>
      '/auth/whitelabel/$baseUrl';
}
