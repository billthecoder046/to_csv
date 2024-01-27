import 'package:flutter_test/flutter_test.dart';

import 'package:to_csv/to_csv_io.dart';

void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());
  test('Shuld throws assertion error when `headerRow` is empty', () async {
    expectLater(
      () => toCsv(
        [],
        [
          ['a', 'b']
        ],
      ),
      throwsA(
        isA<AssertionError>().having(
          (e) => e.message,
          'message',
          equals('Header row list is empty'),
        ),
      ),
    );
  });

  test('Shuld throws assertion error when `content` is empty', () async {
    expectLater(
      () => toCsv(
        ['a', 'b'],
        [],
      ),
      throwsA(
        isA<AssertionError>().having(
          (e) => e.message,
          'message',
          equals('Content list is empty'),
        ),
      ),
    );
  });

  test('Shuld throws assertion error when `fileName` not end with `.csv`',
      () async {
    expectLater(
      () => toCsv([
        'a',
        'b'
      ], [
        ['1', '2'],
      ], fileName: 'project'),
      throwsA(
        isA<AssertionError>().having(
          (e) => e.message,
          'message',
          equals('The fileName must be end with `.csv`'),
        ),
      ),
    );
  });

  test('Shuld not throws assertion error when `fileName` is null', () async {
    expectLater(
      () => toCsv(
        ['a', 'b'],
        [
          ['1', '2'],
        ],
      ),
      isNot(isAssertionError),
    );
  });
}
