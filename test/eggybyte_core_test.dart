import 'package:flutter_test/flutter_test.dart';

import 'package:eggybyte_core/eggybyte_core.dart';

void main() {
  group('EggyByteCore Configuration Tests', () {
    tearDown(() {
      // Reset to defaults after each test
      EggyByteCore.configureLogging(enableColors: true, enableBold: true);
    });

    test('setTargetPlatform sets platform correctly', () {
      EggyByteCore.setTargetPlatform(TargetPlatform.android);
      expect(EggyByteCore.getTargetPlatform(), TargetPlatform.android);

      EggyByteCore.setTargetPlatform(TargetPlatform.ios);
      expect(EggyByteCore.getTargetPlatform(), TargetPlatform.ios);

      EggyByteCore.setTargetPlatform(TargetPlatform.web);
      expect(EggyByteCore.getTargetPlatform(), TargetPlatform.web);
    });

    test('getPlatformPrefix returns correct prefix', () {
      EggyByteCore.setTargetPlatform(TargetPlatform.android);
      expect(EggyByteCore.getPlatformPrefix(), 'ANDROID NATIVE');

      EggyByteCore.setTargetPlatform(TargetPlatform.ios);
      expect(EggyByteCore.getPlatformPrefix(), 'IOS NATIVE');

      EggyByteCore.setTargetPlatform(TargetPlatform.windows);
      expect(EggyByteCore.getPlatformPrefix(), 'WINDOWS NATIVE');

      EggyByteCore.setTargetPlatform(TargetPlatform.macos);
      expect(EggyByteCore.getPlatformPrefix(), 'MACOS NATIVE');

      EggyByteCore.setTargetPlatform(TargetPlatform.linux);
      expect(EggyByteCore.getPlatformPrefix(), 'LINUX NATIVE');

      EggyByteCore.setTargetPlatform(TargetPlatform.web);
      expect(EggyByteCore.getPlatformPrefix(), 'WEB NATIVE');
    });

    test('configureLogging runs without errors', () {
      expect(
          () => EggyByteCore.configureLogging(
              enableColors: true, enableBold: true),
          returnsNormally);
      expect(
          () => EggyByteCore.configureLogging(
              enableColors: false, enableBold: false),
          returnsNormally);
      expect(
          () => EggyByteCore.configureLogging(
              enableColors: true, enableBold: false),
          returnsNormally);
      expect(
          () => EggyByteCore.configureLogging(
              enableColors: false, enableBold: true),
          returnsNormally);
    });

    test('TargetPlatform enum has all expected values', () {
      final platforms = TargetPlatform.values;
      expect(platforms, contains(TargetPlatform.android));
      expect(platforms, contains(TargetPlatform.ios));
      expect(platforms, contains(TargetPlatform.web));
      expect(platforms, contains(TargetPlatform.windows));
      expect(platforms, contains(TargetPlatform.macos));
      expect(platforms, contains(TargetPlatform.linux));
      expect(platforms.length, 6);
    });
  });

  group('Enhanced LoggingUtils Tests', () {
    setUp(() {
      // Ensure logging is in a known state
      LoggingUtils.configureFormatting(enableColors: true, enableBold: true);
    });

    test('Basic logging methods run without errors', () {
      expect(() => LoggingUtils.info('Test info message from unit test'),
          returnsNormally);
      expect(() => LoggingUtils.warning('Test warning message from unit test'),
          returnsNormally);
      expect(
          () => LoggingUtils.error('Test error message from unit test',
              stackTrace: StackTrace.current),
          returnsNormally);
      expect(() => LoggingUtils.debug('Test debug message from unit test'),
          returnsNormally);
    });

    test('configureFormatting runs without errors', () {
      expect(
          () => LoggingUtils.configureFormatting(
              enableColors: true, enableBold: true),
          returnsNormally);
      expect(
          () => LoggingUtils.configureFormatting(
              enableColors: false, enableBold: false),
          returnsNormally);
    });

    test('Native logging methods run without errors', () {
      expect(
          () => LoggingUtils.logNative('Test native message'), returnsNormally);
      expect(
          () => LoggingUtils.logNative('Test native message',
              platformPrefix: 'TEST NATIVE'),
          returnsNormally);
      expect(
          () =>
              LoggingUtils.logNative('Test native error', type: LogType.error),
          returnsNormally);
    });

    test('Native logging convenience methods run without errors', () {
      expect(
          () => LoggingUtils.nativeInfo('Native info test'), returnsNormally);
      expect(() => LoggingUtils.nativeWarning('Native warning test'),
          returnsNormally);
      expect(
          () => LoggingUtils.nativeError('Native error test'), returnsNormally);
      expect(
          () => LoggingUtils.nativeDebug('Native debug test'), returnsNormally);
    });

    test('Native logging with custom platform prefix', () {
      expect(
          () => LoggingUtils.nativeInfo('Info test',
              platformPrefix: 'CUSTOM NATIVE'),
          returnsNormally);
      expect(
          () => LoggingUtils.nativeWarning('Warning test',
              platformPrefix: 'CUSTOM NATIVE'),
          returnsNormally);
      expect(
          () => LoggingUtils.nativeError('Error test',
              platformPrefix: 'CUSTOM NATIVE'),
          returnsNormally);
      expect(
          () => LoggingUtils.nativeDebug('Debug test',
              platformPrefix: 'CUSTOM NATIVE'),
          returnsNormally);
    });

    test('Native logging with EggyByteCore platform prefix integration', () {
      EggyByteCore.setTargetPlatform(TargetPlatform.android);
      final prefix = EggyByteCore.getPlatformPrefix();
      expect(prefix, 'ANDROID NATIVE');

      expect(
          () => LoggingUtils.nativeInfo('Integration test',
              platformPrefix: prefix),
          returnsNormally);
    });

    test('LogType enum values are correct', () {
      expect(LogType.info.toString(), 'LogType.info');
      expect(LogType.warning.toString(), 'LogType.warning');
      expect(LogType.error.toString(), 'LogType.error');
      expect(LogType.debug.toString(), 'LogType.debug');
    });
  });

  group('FormatUtils Tests', () {
    final DateTime testDateTime = DateTime(2023, 10, 27, 14, 30, 55);
    final DateTime testDateOnly = DateTime(2023, 10, 27);

    // --- Time Formatting Tests ---
    test('formatTimeSymbolSeparated default separator', () {
      expect(FormatUtils.formatTimeSymbolSeparated(testDateTime), '14:30:55');
    });

    test('formatTimeSymbolSeparated custom separator', () {
      expect(
        FormatUtils.formatTimeSymbolSeparated(testDateTime, separator: '-'),
        '14-30-55',
      );
    });

    test('formatTimeSymbolSeparated edge cases', () {
      final earlyMorning = DateTime(2023, 1, 1, 0, 5, 9);
      expect(FormatUtils.formatTimeSymbolSeparated(earlyMorning), '00:05:09');

      final lateEvening = DateTime(2023, 12, 31, 23, 59, 59);
      expect(FormatUtils.formatTimeSymbolSeparated(lateEvening), '23:59:59');
    });

    test('formatTimeChineseSeparated', () {
      expect(FormatUtils.formatTimeChineseSeparated(testDateTime), '14时30分55秒');
    });

    test('formatTimeChineseSeparated edge cases', () {
      final earlyMorning = DateTime(2023, 1, 1, 0, 5, 9);
      expect(FormatUtils.formatTimeChineseSeparated(earlyMorning), '00时05分09秒');

      final lateEvening = DateTime(2023, 12, 31, 23, 59, 59);
      expect(FormatUtils.formatTimeChineseSeparated(lateEvening), '23时59分59秒');
    });

    // --- Date Formatting Tests ---
    test('formatDateSymbolSeparated default separator', () {
      expect(FormatUtils.formatDateSymbolSeparated(testDateOnly), '2023-10-27');
    });

    test('formatDateSymbolSeparated custom separator', () {
      expect(
        FormatUtils.formatDateSymbolSeparated(testDateOnly, separator: '/'),
        '2023/10/27',
      );
      expect(
        FormatUtils.formatDateSymbolSeparated(testDateOnly, separator: '.'),
        '2023.10.27',
      );
    });

    test('formatDateSymbolSeparated edge cases', () {
      final newYear = DateTime(2024, 1, 1);
      expect(FormatUtils.formatDateSymbolSeparated(newYear), '2024-01-01');

      final lastDayOfYear = DateTime(2023, 12, 31);
      expect(
          FormatUtils.formatDateSymbolSeparated(lastDayOfYear), '2023-12-31');
    });

    test('formatDateChineseSeparated', () {
      expect(
        FormatUtils.formatDateChineseSeparated(testDateOnly),
        '2023年10月27日',
      );
    });

    test('formatDateChineseSeparated edge cases', () {
      final newYear = DateTime(2024, 1, 1);
      expect(FormatUtils.formatDateChineseSeparated(newYear), '2024年01月01日');

      final lastDayOfYear = DateTime(2023, 12, 31);
      expect(
          FormatUtils.formatDateChineseSeparated(lastDayOfYear), '2023年12月31日');
    });

    // --- Number Formatting Tests ---
    test('formatNumberDecimalPlaces', () {
      expect(FormatUtils.formatNumberDecimalPlaces(123.456, 2), '123.46');
      expect(FormatUtils.formatNumberDecimalPlaces(123.456, 0), '123');
      expect(FormatUtils.formatNumberDecimalPlaces(123, 2), '123.00');
      expect(FormatUtils.formatNumberDecimalPlaces(123.456, 5), '123.45600');
      expect(FormatUtils.formatNumberDecimalPlaces(0.12345, 3), '0.123');
    });

    test('formatNumberDecimalPlaces edge cases', () {
      expect(FormatUtils.formatNumberDecimalPlaces(0, 2), '0.00');
      expect(FormatUtils.formatNumberDecimalPlaces(-123.456, 2), '-123.46');
      expect(
          FormatUtils.formatNumberDecimalPlaces(999999.999, 2), '1000000.00');
    });

    test('formatNumberDecimalPlaces negative decimal places', () {
      // Should handle negative decimal places gracefully
      expect(FormatUtils.formatNumberDecimalPlaces(123.456, -1), '123');
    });

    test('formatNumberWithUnits', () {
      expect(
        FormatUtils.formatNumberWithUnits(12345, decimalPlaces: 1),
        '1.2万',
      );
      expect(
        FormatUtils.formatNumberWithUnits(123456789, decimalPlaces: 2),
        '1.23亿',
      );
      expect(
        FormatUtils.formatNumberWithUnits(5000, decimalPlaces: 1),
        '5000.0',
      ); // Less than 1万
      expect(FormatUtils.formatNumberWithUnits(10000, decimalPlaces: 0), '1万');
      expect(FormatUtils.formatNumberWithUnits(9999, decimalPlaces: 0), '9999');
      expect(
        FormatUtils.formatNumberWithUnits(1234567890, decimalPlaces: 2),
        '12.35亿',
      );
      expect(
        FormatUtils.formatNumberWithUnits(100000000, decimalPlaces: 0),
        '1亿',
      );
    });

    test('formatNumberWithUnits negative numbers', () {
      expect(
        FormatUtils.formatNumberWithUnits(-12345, decimalPlaces: 1),
        '-1.2万',
      );
      expect(
        FormatUtils.formatNumberWithUnits(-123456789, decimalPlaces: 2),
        '-1.23亿',
      );
    });

    test('formatNumberWithUnits edge cases', () {
      expect(FormatUtils.formatNumberWithUnits(0), '0.00');
      expect(FormatUtils.formatNumberWithUnits(9999.99), '9999.99');
      expect(FormatUtils.formatNumberWithUnits(10000.00), '1.00万');
      expect(FormatUtils.formatNumberWithUnits(99999999), '10000.00万');
      expect(FormatUtils.formatNumberWithUnits(100000000), '1.00亿');
    });

    test('formatNumberWithUnits negative decimal places', () {
      // Should handle negative decimal places gracefully
      expect(FormatUtils.formatNumberWithUnits(12345, decimalPlaces: -1), '1万');
    });
  });

  group('NetworkUtils Tests', () {
    tearDown(() {
      // Clean up after each test
      NetworkUtils.clearBearerToken();
    });

    test('Bearer token management', () {
      NetworkUtils.setBearerToken('test_token_123');
      // Token is set - verified by no exceptions
      NetworkUtils.clearBearerToken();
      // Token is cleared - verified by no exceptions
      expect(true, isTrue);
    });

    test('Multiple token operations', () {
      NetworkUtils.setBearerToken('first_token');
      NetworkUtils.setBearerToken('second_token'); // Should replace first
      NetworkUtils.clearBearerToken();
      NetworkUtils
          .clearBearerToken(); // Should handle clearing already cleared token
      expect(true, isTrue);
    });

    test('Empty and null token handling', () {
      expect(() => NetworkUtils.setBearerToken(''), returnsNormally);
      expect(() => NetworkUtils.clearBearerToken(), returnsNormally);
    });

    test('HTTP methods can be instantiated (requires mocks for full test)',
        () async {
      // These will throw errors if not mocked, as they try to make real HTTP calls.
      // This is just a placeholder to indicate where tests would go.
      // For real tests, use package:mockito or package:http_mock_adapter.

      // Basic instantiation test - methods exist and can be called
      expect(NetworkUtils.get, isA<Function>());
      expect(NetworkUtils.post, isA<Function>());

      // Note: Actual HTTP tests would require mocking:
      // try {
      //   await NetworkUtils.get('https://jsonplaceholder.typicode.com/todos/1');
      // } catch (e) {
      //   // Expected to fail without mocks or network access
      // }
    });
  });

  group('StorageUtils Tests', () {
    test('Storage methods are available', () {
      // Tests for StorageUtils would typically require mocking path_provider
      // and dart:io, or performing actual file I/O in a controlled test environment.

      expect(StorageUtils.saveToFile, isA<Function>());
      expect(StorageUtils.readFromFile, isA<Function>());
      expect(StorageUtils.deleteFile, isA<Function>());

      // Note: Actual file I/O tests would require setup:
      // final fileName = 'test_storage.txt';
      // await StorageUtils.saveToFile(fileName, 'Hello Storage');
      // final content = await StorageUtils.readFromFile(fileName);
      // expect(content, 'Hello Storage');
      // await StorageUtils.deleteFile(fileName);
    });
  });

  group('ScreenUtils Tests', () {
    test('Screen methods are available', () {
      // ScreenUtils methods usually require a Flutter widget tree context (BuildContext)
      // or mocking of ui.PlatformDispatcher and MediaQuery.

      expect(ScreenUtils.getDeviceScreenWidth, isA<Function>());
      expect(ScreenUtils.getDeviceScreenHeight, isA<Function>());
      expect(ScreenUtils.getContextWidth, isA<Function>());
      expect(ScreenUtils.getContextHeight, isA<Function>());

      // Note: Actual screen tests would require Flutter test environment:
      // testWidgets('ScreenUtils context methods', (WidgetTester tester) async {
      //   await tester.pumpWidget(MyTestWidget());
      //   final context = tester.element(find.byType(MyTestWidget));
      //   final width = ScreenUtils.getContextWidth(context);
      //   expect(width, greaterThan(0));
      // });
    });
  });

  group('Integration Tests', () {
    test('EggyByteCore and LoggingUtils integration', () {
      // Test the integration between EggyByteCore and LoggingUtils
      EggyByteCore.setTargetPlatform(TargetPlatform.android);
      EggyByteCore.configureLogging(enableColors: false, enableBold: false);

      final prefix = EggyByteCore.getPlatformPrefix();
      expect(prefix, 'ANDROID NATIVE');

      // Test native logging with platform prefix
      expect(
          () => LoggingUtils.nativeInfo('Integration test',
              platformPrefix: prefix),
          returnsNormally);
      expect(
          () => LoggingUtils.nativeDebug('Debug integration',
              platformPrefix: prefix),
          returnsNormally);
    });

    test('Full workflow test', () {
      // Test a complete workflow
      EggyByteCore.setTargetPlatform(TargetPlatform.ios);
      EggyByteCore.configureLogging(enableColors: true, enableBold: true);

      final prefix = EggyByteCore.getPlatformPrefix();
      expect(prefix, 'IOS NATIVE');

      // Use various utilities
      LoggingUtils.info('Starting workflow test');
      LoggingUtils.nativeInfo('Native iOS operation', platformPrefix: prefix);

      final now = DateTime.now();
      final timeFormatted = FormatUtils.formatTimeChineseSeparated(now);
      LoggingUtils.debug('Time formatted: $timeFormatted');

      NetworkUtils.setBearerToken('workflow_token');
      LoggingUtils.info('Network configured');
      NetworkUtils.clearBearerToken();

      LoggingUtils.info('Workflow test completed');
      expect(true, isTrue);
    });

    test('Platform switching test', () {
      final platforms = [
        TargetPlatform.android,
        TargetPlatform.ios,
        TargetPlatform.web,
        TargetPlatform.windows,
        TargetPlatform.macos,
        TargetPlatform.linux,
      ];

      for (final platform in platforms) {
        EggyByteCore.setTargetPlatform(platform);
        expect(EggyByteCore.getTargetPlatform(), platform);

        final prefix = EggyByteCore.getPlatformPrefix();
        expect(prefix, contains('NATIVE'));
        expect(prefix, contains(platform.name.toUpperCase()));

        LoggingUtils.nativeInfo('Testing platform ${platform.name}',
            platformPrefix: prefix);
      }
    });
  });
}
