import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

class DigitSpecs {
  final double width;
  final double height;
  final List<Point> _vertices;

  DigitSpecs(this.width, this.height, this._vertices);

  double getAspectRatio() => width / height;

  Path draw(Size size) {
    Path path = Path();
    var points = rescaleVertices(size);
    var first = points.first;
    path.moveTo(first.x, first.y);
    for (var point in points) {
      path.lineTo(point.x, point.y);
    }
    return path;
  }

  List<Point> rescaleVertices(Size size) {
    var ratio = size.height / height;
    return _vertices
        .map((point) => Point(point.x * ratio, point.y * ratio))
        .toList();
  }
}

List<DigitSpecs> digitSpecs = [
  DigitSpecs(268.0, 268.0, List()),
  DigitSpecs(268.0, 268.0, List()),
  DigitSpecs(268.0, 268.0, List()),
  DigitSpecs(268.0, 268.0, _vertices3),
  DigitSpecs(268.0, 268.0, _vertices4),
  DigitSpecs(282.0, 268.0, _vertices5),
  DigitSpecs(234.0, 268.0, _vertices6),
  DigitSpecs(276.0, 269.0, _vertices7),
  DigitSpecs(268.0, 268.0, _vertices8),
  DigitSpecs(272.0, 268.0, _vertices9),
];

List<Point> _vertices3 = [
  Point(0.0, 267.75),
  Point(310.086, 267.75),
  Point(155.5, 0.0),
  Point(0.0, 267.75)
];

List<Point> _vertices4 = [
  Point(0.0, 0.0),
  Point(267.75, 0.0),
  Point(267.75, 267.75),
  Point(0.0, 267.75),
  Point(0.0, 0.0)
];

List<Point> _vertices5 = [
  Point(141.0, 0.0),
  Point(281.756, 102.265),
  Point(227.992, 267.734),
  Point(54.0078, 267.734),
  Point(0.243637, 102.265),
  Point(141.0, 0.0),
];

List<Point> _vertices6 = [
  Point(117.0, 0.0),
  Point(233.047, 67.0),
  Point(233.047, 201.0),
  Point(117.0, 268.0),
  Point(0.952599, 201.0),
  Point(0.952599, 67.0),
  Point(0.952599, 67.0),
  Point(117.0, 0.0),
];

List<Point> _vertices7 = [
  Point(138.0, 0.0),
  Point(248.238, 53.0879),
  Point(275.465, 172.375),
  Point(199.178, 268.037),
  Point(76.8224, 268.037),
  Point(0.535172, 172.375),
  Point(27.7618, 53.0879),
  Point(138.0, 0.0),
];

List<Point> _vertices8 = [
  Point(134.0, 0.0),
  Point(228.752, 39.2477),
  Point(268.0, 134.0),
  Point(228.752, 228.752),
  Point(134.0, 268.0),
  Point(39.2477, 228.752),
  Point(0.0, 134.0),
  Point(39.2477, 39.2477),
  Point(134.0, 0.0),
];

List<Point> _vertices9 = [
  Point(136.0, 0.0),
  Point(224.705, 32.2859),
  Point(271.903, 114.037),
  Point(255.512, 207.0),
  Point(183.199, 267.678),
  Point(88.8012, 267.678),
  Point(16.4885, 207.0),
  Point(0.0965271, 114.037),
  Point(47.2953, 32.2859),
  Point(47.2953, 32.2859),
  Point(136.0, 0.0),
];
