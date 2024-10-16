import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_new_app/utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class PolygonAnnotationExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Polygon Annotations';
  @override
  final String? subtitle = null;

  @override
  State<StatefulWidget> createState() => PolygonAnnotationExampleState();
}

class AnnotationClickListener extends OnPolygonAnnotationClickListener {
  AnnotationClickListener({
    required this.onAnnotationClick,
  });

  final void Function(PolygonAnnotation annotation) onAnnotationClick;

  @override
  void onPolygonAnnotationClick(PolygonAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
    onAnnotationClick(annotation);
  }
}

class PolygonAnnotationExampleState extends State<PolygonAnnotationExample> {
  PolygonAnnotationExampleState();

  MapboxMap? mapboxMap;
  PolygonAnnotation? polygonAnnotation;
  PolygonAnnotationManager? polygonAnnotationManager;
  int styleIndex = 1;

  static Future<void> initSymbolSource(MapboxMap mapboxMap, String localeLanguage) async {
    final ByteData bytesSlowZone = await rootBundle.load("assets/images/slow_zone.png");
    final Uint8List listSlowZone = bytesSlowZone.buffer.asUint8List();
    await mapboxMap.style
        .addStyleImage("slow-zone", 3, MbxImage(width: 384, height: 384, data: listSlowZone), true, [], [], null);
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(CameraOptions(center: Point(coordinates: Position(-3.363937, -10.733102)), zoom: 1, pitch: 0));
    mapboxMap.annotations.createPolygonAnnotationManager().then((value) {
      polygonAnnotationManager = value;
      createOneAnnotation();
      var options = <PolygonAnnotationOptions>[];
      for (var i = 0; i < 2; i++) {
        options.add(PolygonAnnotationOptions(
            geometry: Polygon(coordinates: createRandomPositionsList()),
            fillPattern: 'slow-zone',
            fillOutlineColor: createRandomColor()));
      }
      polygonAnnotationManager?.createMulti(options);
      polygonAnnotationManager?.addOnPolygonAnnotationClickListener(
        AnnotationClickListener(
          onAnnotationClick: (annotation) => polygonAnnotation = annotation,
        ),
      );
    });
  }

  void createOneAnnotation() {
    polygonAnnotationManager
        ?.create(PolygonAnnotationOptions(
            geometry: Polygon(coordinates: [
              [
                Position(-3.363937, -10.733102),
                Position(1.754703, -19.716317),
                Position(-15.747196, -21.085074),
                Position(-3.363937, -10.733102)
              ]
            ]),
            fillColor: Colors.red.value,
            fillOutlineColor: Colors.purple.value))
        .then((value) => polygonAnnotation = value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _update() {
    return TextButton(
      child: Text('update a polygon annotation'),
      onPressed: () {
        if (polygonAnnotation != null) {
          var polygon = polygonAnnotation!.geometry;
          var newPolygon = Polygon(
              coordinates:
                  polygon.coordinates.map((e) => e.map((e) => Position(e.lng + 1.0, e.lat + 1.0)).toList()).toList());
          polygonAnnotation?.geometry = newPolygon;
          polygonAnnotationManager?.update(polygonAnnotation!);
        }
      },
    );
  }

  Widget _create() {
    return TextButton(
      child: Text('create a polygon annotation'),
      onPressed: () {
        createOneAnnotation();
      },
    );
  }

  Widget _delete() {
    return TextButton(
      child: Text('delete a polygon annotation'),
      onPressed: () {
        if (polygonAnnotation != null) {
          polygonAnnotationManager?.delete(polygonAnnotation!);
          polygonAnnotation = null;
        }
      },
    );
  }

  Widget _deleteAll() {
    return TextButton(
      child: Text('delete all polygon annotations'),
      onPressed: () {
        polygonAnnotationManager?.deleteAll();
        polygonAnnotation = null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      onMapIdleListener: (_) async {
        initSymbolSource(mapboxMap!, "en");
      },
    );

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[_create(), _update(), _delete(), _deleteAll()],
    );

    final colmn = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              child: mapWidget),
        ),
        Expanded(
          child: ListView(
            children: listViewChildren,
          ),
        )
      ],
    );

    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                  child: Icon(Icons.swap_horiz),
                  heroTag: null,
                  onPressed: () {
                    mapboxMap?.style.setStyleURI(annotationStyles[++styleIndex % annotationStyles.length]);
                  }),
              SizedBox(height: 10),
              FloatingActionButton(
                  child: Icon(Icons.clear),
                  heroTag: null,
                  onPressed: () {
                    if (polygonAnnotationManager != null) {
                      mapboxMap?.annotations.removeAnnotationManager(polygonAnnotationManager!);
                      polygonAnnotationManager = null;
                    }
                  }),
            ],
          ),
        ),
        body: colmn);
  }
}
