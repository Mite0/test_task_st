class Course {
  final String shortName;
  final int scale;
  final String name;
  final double course1;
  final double course2;
  bool selected;

  Course({
    required this.shortName,
    required this.scale,
    required this.name,
    required this.course1,
    required this.course2,
    this.selected = false,
  });

}