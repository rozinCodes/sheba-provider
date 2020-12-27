import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  /*
   * https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
   */
  static Future<void> openMap(double latitude, double longitude) async {
    String mapSchema = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not open map';
    }
  }
}
