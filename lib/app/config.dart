class Config {
  static const String BASE_URL = "http://192.168.9.166:7575/thikthak/";

  // "http://192.168.203.11/thikthak/" (Local server)
  // "http://192.168.100.253:8080/thikthak/" (live server)
  // "http://192.168.9.166:7575/thikthak/" (Arju Vai)
  static const String GENERATE_ACCESS_TOKEN = BASE_URL + "api/login";
  static const String SERVICE_ITEMS = BASE_URL + "api/serviceItems";
  static const String GET_USER_DATA = BASE_URL + "api/user/search";
  static const String REGISTER_USER = BASE_URL + "api/user";
  static const String UPDATE_USER_INFO = BASE_URL + "api/user/";
  static const String UPLOAD_PROFILE_IMAGE = BASE_URL + "api/user/updateUserProfile";
  static const String GET_TECHNICIAN_RATING = BASE_URL + "api/user/getTechnicianRating";
  static const String NEAREST_TECHNICIAN = BASE_URL + "api/getNearestTechnicians";
  static const String PLACE_ORDER = BASE_URL + "api/serviceOrders";
  static const String ORDER_LIST = BASE_URL + "api/serviceOrders";
  static const String ADD_COST = BASE_URL + "api/serviceOrders/addOrderCost";
  static const String NOTIFICATION = BASE_URL + "api/notification";
  static const String FAVOURITE_LIST = BASE_URL + "api/favoriteTechnician";
  static const String PROMO_OFFER = BASE_URL + "api/offerPromos";
  static const String DUE_AMOUNT = BASE_URL + "api/serviceOrders/getDueAmount/";
  static const String LOGOUT_USER = BASE_URL + "api/setOfflineUser";

  static const String PROFILE_IMAGE_URL = BASE_URL + "user/showFile?imageName=";
  static const String USER_LOCATION_UPDATE = BASE_URL + "api/userLocation/userLocationUpdate";

  static const String ROOT_URL = "https://api.evaly.com.bd/core/public/";
}
