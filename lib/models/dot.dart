class Dot {
  final String id;
  final List<double> gridPosition;
  final String cloudAnchorId;

  Dot(
      {required this.id,
      required this.gridPosition,
      required this.cloudAnchorId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'gridPosition': gridPosition,
        'cloudAnchorId': cloudAnchorId,
      };

  factory Dot.fromJson(Map<String, dynamic> json) => Dot(
        id: json['id'],
        gridPosition: List<double>.from(json['gridPosition']),
        cloudAnchorId: json['cloudAnchorId'],
      );
}
