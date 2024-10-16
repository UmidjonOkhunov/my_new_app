import 'package:flutter/material.dart';
import 'package:my_new_app/animated_route_example.dart';
import 'package:my_new_app/animation_example.dart';
import 'package:my_new_app/camera_example.dart';
import 'package:my_new_app/circle_annotations_example.dart';
import 'package:my_new_app/cluster_example.dart';
import 'package:my_new_app/offline_map_example.dart';
import 'package:my_new_app/model_layer_example.dart';
import 'package:my_new_app/ornaments_example.dart';
import 'package:my_new_app/geojson_line_example.dart';
import 'package:my_new_app/image_source_example.dart';
import 'package:my_new_app/map_interface_example.dart';
import 'package:my_new_app/polygon_annotations_example.dart';
import 'package:my_new_app/polyline_annotations_example.dart';
import 'package:my_new_app/snapshotter_example.dart';
import 'package:my_new_app/traffic_route_line_example.dart';
import 'package:my_new_app/tile_json_example.dart';
import 'package:my_new_app/vector_tile_source_example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'full_map_example.dart';
import 'location_example.dart';
import 'example.dart';
import 'point_annotations_example.dart';
import 'projection_example.dart';
import 'style_example.dart';
import 'gestures_example.dart';
import 'debug_options_example.dart';

final List<Example> _allPages = <Example>[
  SnapshotterExample(),
  TrafficRouteLineExample(),
  OfflineMapExample(),
  ModelLayerExample(),
  DebugOptionsExample(),
  FullMapExample(),
  StyleExample(),
  CameraExample(),
  ProjectionExample(),
  MapInterfaceExample(),
  StyleClustersExample(),
  AnimationExample(),
  PointAnnotationExample(),
  CircleAnnotationExample(),
  PolylineAnnotationExample(),
  PolygonAnnotationExample(),
  VectorTileSourceExample(),
  DrawGeoJsonLineExample(),
  ImageSourceExample(),
  TileJsonExample(),
  LocationExample(),
  GesturesExample(),
  OrnamentsExample(),
  AnimatedRouteExample(),
];

class MapsDemo extends StatelessWidget {
  // FIXME: You need to pass in your access token via the command line argument
  // --dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE
  // It is also possible to pass it in while running the app via an IDE by
  // passing the same args there.
  //
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  static const String ACCESS_TOKEN =
      "pk.eyJ1IjoicmlkZWJlYW0iLCJhIjoiY2s4anNycGZ2MDU5eTNlbXlqZWw2ODAwOCJ9.yRwwVUur6KtGmYpabFefyQ";

  void _pushPage(BuildContext context, Example page) async {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ACCESS_TOKEN.isEmpty || ACCESS_TOKEN.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, int index) {
                final example = _allPages[index];
                return ListTile(
                  leading: example.leading,
                  title: Text(example.title),
                  subtitle: (example.subtitle?.isNotEmpty == true)
                      ? Text(
                          example.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () => _pushPage(context, _allPages[index]),
                );
              },
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(MapsDemo.ACCESS_TOKEN);
  runApp(MaterialApp(home: MapsDemo()));
}
