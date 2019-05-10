// PlaceService.dart
// Decode polyline points
List<LatLng> decodePoints(final String encodedPath) {
  int len = encodedPath.length;
  final List<LatLng> path = <LatLng>[];
  int index = 0;
  int lat = 0;
  int lng = 0;
  while (index < len) {
    int result = 1;
    int shift = 0;
    int b;
    do {
      b = encodedPath.codeUnitAt(index++) - 63 - 1;
      result += b << shift;
      shift += 5;
    } while (b >= 0x1f);
    lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    result = 1;
    shift = 0;
    do {
      b = encodedPath.codeUnitAt(index++) - 63 - 1;
      result += b << shift;
      shift += 5;
    } while (b >= 0x1f);
    lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    path.add(LatLng(lat * 1e-5, lng * 1e-5));
  }
  return path;
}
  
// Parse json response to list LatLng
List<LatLng> _parsePoints(final responseBody) {
  List<LatLng> list = <LatLng>[];
  for (var response in responseBody) {
    List<LatLng> subList = decodePoints(response["polyline"]["points"]);
    list.addAll(subList);
  }
  return list;
}

// MainBloc.dart
List<LatLng> paths = await placeService.getPolylines(startPaths);
polylines.add(Polyline(
  polylineId: PolylineId("polyline_id"),
  points: paths,
  color: Color(0xFF3ADF00),
  width: 10
));

// HomePage.dart
GoogleMap(
  initialCameraPosition: mainBloc.initPlace(),
  onMapCreated: (controller) => mainBloc.mapCreated(controller),
  markers: mainBloc.markers,
  polylines: mainBloc.polylines,
)
