/// {@template to_csv_method}
/// Allow to convert `List<List<String>>` to a CSV file.
///
/// The [headerRow] represent the top of the row in CSV file, and [content]
/// all data save in the CSV file.
///
/// If [fileName] is use must end with `.csv`.
///
/// Structure:
/// ```
/// |---|---|
/// | a | b | -> header
/// |---|---|
/// | 1 | 2 | -> content
/// |---|---|
/// | x | y |
/// |---|---|
/// ````
///
/// Example:
///
/// ```dart
/// List<String> header = <String>['a', 'b'];
/// List<List<String>> content =
///    <String>[
///     ['1', '2']
///     ['x', 'y']
///    ];
///
/// toVsc(header, content);
/// ```
/// {@endtemplate}
Future<void> toCsv(
  List<String> headerRow,
  List<List<String>> content, {
  bool sharing = false,
  String? fileName,
}) async {
  throw UnimplementedError('This methods is not implemented in this platform');
}
