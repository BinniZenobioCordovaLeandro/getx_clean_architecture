import 'dart:convert';
import 'package:http/http.dart' as http;

class SutranDataProvider {
  static SutranDataProvider? _instance;

  String? lastUpdate = "";

  List<ReportPoint>? restrictedPoints = [];
  List<ReportPoint>? disruptedPoints = [];

  static SutranDataProvider? getInstance() {
    _instance ??= SutranDataProvider();
    return _instance;
  }

  Future<bool> updateSutranData() async {
    const String sutranDataPath =
        "https://storage.googleapis.com/pickpointer.appspot.com/sutranData.json";

    http.Response response =
        await http.get(Uri.parse(sutranDataPath), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
    });

    final data = const JsonDecoder().convert(response.body);
    lastUpdate = data["fecha_hora_actualizacion"];
    restrictedPoints = _generateListReportPoint(data["restringido"]);
    disruptedPoints = _generateListReportPoint(data["interrumpido"]);

    return Future.value(true);
  }

  List<ReportPoint>? _generateListReportPoint(List data) {
    return data.map((element) => ReportPoint.fromMap(element)).toList();
  }
}

class ReportPoint {
  String? type;
  Geometry? geometry;
  Properties? properties;

  ReportPoint({this.type, this.geometry, this.properties});

  factory ReportPoint.fromMap(Map<String, dynamic> data) => ReportPoint(
        type: data['type'] as String?,
        geometry: data['geometry'] == null
            ? null
            : Geometry.fromMap(data['geometry'] as Map<String, dynamic>),
        properties: data['properties'] == null
            ? null
            : Properties.fromMap(data['properties'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'geometry': geometry?.toMap(),
        'properties': properties?.toMap(),
      };

  factory ReportPoint.fromJson(String data) {
    return ReportPoint.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  factory Geometry.fromMap(Map<String, dynamic> data) => Geometry(
        coordinates: List<double>.from(data['coordinates']),
        type: data['type'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'coordinates': coordinates,
        'type': type,
      };

  factory Geometry.fromJson(String data) {
    return Geometry.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

class Properties {
  String? item;
  String? visualizacion;
  String? tipoAlerta;
  String? estado;
  String? fechaEvento;
  String? fechaActualizacion;
  String? ubigeo;
  String? afectacion;
  String? evento;
  String? latitud;
  String? longitud;
  String? cantVehiculosDetenidosPasajeros;
  String? cantVehiculosDetenidosMercancias;
  String? fuente;
  String? motivo;
  String? codigoVia;
  String? nombreCarretera;
  String? alertaActiva24Horas;

  Properties({
    this.item,
    this.visualizacion,
    this.tipoAlerta,
    this.estado,
    this.fechaEvento,
    this.fechaActualizacion,
    this.ubigeo,
    this.afectacion,
    this.evento,
    this.latitud,
    this.longitud,
    this.cantVehiculosDetenidosPasajeros,
    this.cantVehiculosDetenidosMercancias,
    this.fuente,
    this.motivo,
    this.codigoVia,
    this.nombreCarretera,
    this.alertaActiva24Horas,
  });

  factory Properties.fromMap(Map<String, dynamic> data) => Properties(
        item: data['item'] as String?,
        visualizacion: data['visualizacion_'] as String?,
        tipoAlerta: data['tipo_alerta_'] as String?,
        estado: data['estado'] as String?,
        fechaEvento: data['fecha_evento'] as String?,
        fechaActualizacion: data['fecha_actualizacion'] as String?,
        ubigeo: data['ubigeo'] as String?,
        afectacion: data['afectacion'] as String?,
        evento: data['evento'] as String?,
        latitud: data['latitud'] as String?,
        longitud: data['longitud'] as String?,
        cantVehiculosDetenidosPasajeros:
            data['cant_vehiculos_detenidos_pasajeros'] as String?,
        cantVehiculosDetenidosMercancias:
            data['cant_vehiculos_detenidos_mercancias'] as String?,
        fuente: data['fuente'] as String?,
        motivo: data['motivo'] as String?,
        codigoVia: data['codigo_via'] as String?,
        nombreCarretera: data['nombre_carretera'] as String?,
        alertaActiva24Horas: data['alerta_activa_24_horas'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'item': item,
        'visualizacion_': visualizacion,
        'tipo_alerta_': tipoAlerta,
        'estado': estado,
        'fecha_evento': fechaEvento,
        'fecha_actualizacion': fechaActualizacion,
        'ubigeo': ubigeo,
        'afectacion': afectacion,
        'evento': evento,
        'latitud': latitud,
        'longitud': longitud,
        'cant_vehiculos_detenidos_pasajeros': cantVehiculosDetenidosPasajeros,
        'cant_vehiculos_detenidos_mercancias': cantVehiculosDetenidosMercancias,
        'fuente': fuente,
        'motivo': motivo,
        'codigo_via': codigoVia,
        'nombre_carretera': nombreCarretera,
        'alerta_activa_24_horas': alertaActiva24Horas,
      };

  factory Properties.fromJson(String data) {
    return Properties.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
