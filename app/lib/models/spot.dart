/// Status keys ported from `const STATUS = { ok, watch, closed }`.
const Map<String, String> statusLabels = {
  'ok': 'skateable',
  'watch': 'bust risk',
  'closed': 'knobbed',
};

/// Tag vocabulary ported from `const TAGS = [...]` — all singular.
const List<String> allTags = [
  'ledge',
  'hubba ledge',
  'rail',
  'bank',
  'gap',
  'manny pad',
  'slappy',
  'curb',
  'park',
  'hangout',
  'dork stuff',
];

class Spot {
  Spot({
    required this.id,
    required this.name,
    required this.tags,
    required this.lat,
    required this.lng,
    required this.status,
    required this.by,
    required this.edits,
    required this.coords,
    required this.confirmed,
    required this.lastEditor,
    required this.beta,
    required this.specs,
    this.photos = const [],
  });

  final String id;
  final String name;
  final List<String> tags;
  final double lat;
  final double lng;
  final String status;
  final String by;
  final int edits;
  final String coords;
  final String confirmed;
  final String lastEditor;
  final String beta;
  final List<(String, String)> specs;
  final List<String> photos;

  Spot copyWith({
    String? name,
    List<String>? tags,
    String? status,
    int? edits,
    String? confirmed,
    String? lastEditor,
    String? beta,
    List<String>? photos,
  }) {
    return Spot(
      id: id,
      name: name ?? this.name,
      tags: tags ?? this.tags,
      lat: lat,
      lng: lng,
      status: status ?? this.status,
      by: by,
      edits: edits ?? this.edits,
      coords: coords,
      confirmed: confirmed ?? this.confirmed,
      lastEditor: lastEditor ?? this.lastEditor,
      beta: beta ?? this.beta,
      specs: specs,
      photos: photos ?? this.photos,
    );
  }
}
