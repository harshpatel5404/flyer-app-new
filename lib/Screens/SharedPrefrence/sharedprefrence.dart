import 'package:shared_preferences/shared_preferences.dart';

Future setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('token');
}

Future setId(String id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('Id', id);
}

Future<String?> getId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('Id');
}

Future setName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
}

Future<String?> getName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('name');
}

Future removeName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('name');
}

Future setEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
}

Future<String?> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future removeEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('email');
}

Future setDisplayPicture(String displayPicture) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('displayPicture', displayPicture);
}

Future<String?> getDisplayPicture() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('displayPicture');
}

Future removeDisplayPicture() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('drivingLicense');
}

Future setDrivingLicense(String drivingLicense) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('drivingLicense', drivingLicense);
}

Future<String?> getDrivingLicense() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('drivingLicense');
}

Future removeDrivingLicense() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove('drivingLicense');
}

Future setPhoneNumber(String phoneNumber) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('phoneNumber', phoneNumber);
}

Future getPhoneNumber() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('phoneNumber');
}

Future setPassword(String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('password', password);
}

Future getPassword() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('setPassword');
}

Future setJobTitle(String jobTitle) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jobTitle', jobTitle);
}

Future getJobTitle() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jobTitle');
}

Future setJobId(String jobId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jobId', jobId);
}

Future getJobId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jobId');
}

Future setJobCreatedDate(String createdAt) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('createdAt', createdAt);
}

Future getJobCreatedDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('createdAt');
}

Future setEndDate(String endDate) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('endDate', endDate);
}

Future getEndDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('endDate');
}

Future setFlyersCount(int flyersCount) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('flyersCount', flyersCount);
}

Future getFlyersCount() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('flyersCount');
}

Future setDoorHangersCount(int doorHangersCount) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('doorHangersCount', doorHangersCount);
}

Future getDoorHangersCount() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('doorHangersCount');
}

Future setHourlyRate(int hourlyRate) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('hourlyRate', hourlyRate);
}

Future getHourlyRate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('hourlyRate');
}

Future setNumOfDaysRequired(int numOfDaysRequired) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('numOfDaysRequired', numOfDaysRequired);
}

Future getNumOfDaysRequired() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('numOfDaysRequired');
}

Future setStartLocation(String startLocation) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('startLocation', startLocation);
}

Future getStartLocation() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('startLocation');
}

Future setEndLocation(String endLocation) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('endLocation', endLocation);
}

Future getEndLocation() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('endLocation');
}

Future setJobIdForShip(String jobIdForShip) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jobIdForShip', jobIdForShip);
}

Future getJobIdForShip() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jobIdForShip');
}

Future setTrackId(String trackId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('trackId', trackId);
}

Future getTrackId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('trackId');
}

Future setShipmentStatus(String status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('status', status);
}

Future getShipmentStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('status');
}

Future setAddress(String address) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('address', address);
}

Future getAddress() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('address');
}

Future setLatitudeStart(double latStart) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latStart', latStart);
}

Future getLatitudeStart() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('latStart');
}

Future setLongitudeStart(double longStart) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('longStart', longStart);
}

Future getLongitudeStart() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('longStart');
}

Future setLatitudeEnd(double latEnd) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latEnd', latEnd);
}

Future getLatitudeEnd() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('latEnd');
}

Future setLongitudeEnd(double longEnd) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('longEnd', longEnd);
}

Future getLongitudeEnd() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('longEnd');
}

Future setReportId(String reportId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('reportId', reportId);
}

Future getReportId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('reportId');
}

Future setFacebookEmail(String FacebookEmail) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('FacebookEmail', FacebookEmail);
}

Future getFacebookEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('FacebookEmail');
}

Future setFacebookName(String FacebookName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('FacebookName', FacebookName);
}

Future getFacebookName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('FacebookName');
}

Future setLockScreenEnable(bool enable) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('lockScreenKey', enable);
}

Future<bool> getLockScreenEnable() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('lockScreenKey') == null) {
    prefs.setBool('lockScreenKey', false);
  }
  return prefs.getBool('lockScreenKey')!;
}

Future setPasscode(String passcode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pinStoreKey', passcode);
}

Future getPasscode() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString('pinStoreKey') == null) {
    prefs.setString('pinStoreKey', "");
  }
  return prefs.getString('pinStoreKey') ?? "";
}
Future removePasscode(String passcode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('pinStoreKey');
}
