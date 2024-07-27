class Grid {
  final int rows;
  final int columns;
  final double cellSize;

  Grid({this.rows = 10, this.columns = 10, this.cellSize = 0.1});

  List<double> worldToGridCoordinates(List<double> worldCoordinates) {
    return [
      (worldCoordinates[0] / cellSize).round().toDouble(),
      (worldCoordinates[1] / cellSize).round().toDouble(),
    ];
  }

  List<double> gridToWorldCoordinates(List<double> gridCoordinates) {
    return [
      gridCoordinates[0] * cellSize,
      gridCoordinates[1] * cellSize,
    ];
  }
}
