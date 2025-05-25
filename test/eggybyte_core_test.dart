import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

import 'package:eggybyte_core/eggybyte_core.dart';

void main() {
  group('EggyByteCore Auto-Initialization Tests', () {
    setUp(() {
      // Reset state before each test
      EggyByteCore.reset();
    });

    tearDown(() {
      // Reset state after each test
      EggyByteCore.reset();
    });

    test('initialize() automatically detects platform and configures logging',
        () {
      expect(EggyByteCore.isInitialized, false);
      expect(EggyByteCore.getTargetPlatform(), null);

      EggyByteCore.initialize();

      expect(EggyByteCore.isInitialized, true);
      expect(EggyByteCore.getTargetPlatform(), isNotNull);
      expect(EggyByteCore.getPlatformPrefix(), isNotNull);
      expect(EggyByteCore.getPlatformPrefix(), contains('NATIVE'));
    });

    test('initialize() with custom logging configuration', () {
      EggyByteCore.initialize(enableColors: false, enableBold: true);

      expect(EggyByteCore.isInitialized, true);
      expect(EggyByteCore.getTargetPlatform(), isNotNull);
    });

    test('initialize() prevents double initialization', () {
      EggyByteCore.initialize();
      expect(EggyByteCore.isInitialized, true);

      // Second initialization should be ignored
      EggyByteCore.initialize(enableColors: false);
      expect(EggyByteCore.isInitialized, true);
    });

    test('reset() resets initialization state', () {
      EggyByteCore.initialize();
      expect(EggyByteCore.isInitialized, true);
      expect(EggyByteCore.getTargetPlatform(), isNotNull);

      EggyByteCore.reset();
      expect(EggyByteCore.isInitialized, false);
      expect(EggyByteCore.getTargetPlatform(), null);
    });

    test('auto-detected platform is valid', () {
      EggyByteCore.initialize();
      final platform = EggyByteCore.getTargetPlatform();

      expect(platform, isNotNull);
      expect(TargetPlatform.values, contains(platform));
    });

    test('getPlatformPrefix returns correct format', () {
      EggyByteCore.initialize();
      final prefix = EggyByteCore.getPlatformPrefix();

      expect(prefix, isNotNull);
      expect(prefix, matches(r'^[A-Z]+ NATIVE$'));
    });

    test('configureLogging works after initialization', () {
      EggyByteCore.initialize();

      expect(
          () => EggyByteCore.configureLogging(
              enableColors: false, enableBold: false),
          returnsNormally);
    });
  });

  group('Enhanced LoggingUtils Tests', () {
    setUp(() {
      EggyByteCore.reset();
      // Initialize EggyByte Core before testing logging
      EggyByteCore.initialize();
    });

    tearDown(() {
      EggyByteCore.reset();
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

    test('Native logging uses EggyByteCore platform prefix automatically', () {
      // Test that logNative without platformPrefix uses EggyByteCore's prefix
      final prefix = EggyByteCore.getPlatformPrefix();
      expect(prefix, isNotNull);
      expect(prefix, contains('NATIVE'));

      expect(() => LoggingUtils.logNative('Auto platform prefix test'),
          returnsNormally);
      expect(() => LoggingUtils.nativeInfo('Auto integration test'),
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
    setUp(() {
      EggyByteCore.reset();
    });

    tearDown(() {
      EggyByteCore.reset();
    });

    test('EggyByteCore auto-initialization with LoggingUtils integration', () {
      // Test the new auto-initialization flow
      EggyByteCore.initialize();

      expect(EggyByteCore.isInitialized, true);
      final platform = EggyByteCore.getTargetPlatform();
      final prefix = EggyByteCore.getPlatformPrefix();

      expect(platform, isNotNull);
      expect(prefix, isNotNull);
      expect(prefix, contains('NATIVE'));

      // Test native logging with auto-detected platform prefix
      expect(() => LoggingUtils.nativeInfo('Auto-initialization test'),
          returnsNormally);
      expect(
          () => LoggingUtils.nativeDebug('Debug integration'), returnsNormally);
    });

    test('Full workflow with auto-initialization', () {
      // Test a complete workflow with new API
      EggyByteCore.initialize(enableColors: true, enableBold: true);

      expect(EggyByteCore.isInitialized, true);
      final platform = EggyByteCore.getTargetPlatform();
      final prefix = EggyByteCore.getPlatformPrefix();

      expect(platform, isNotNull);
      expect(prefix, isNotNull);

      // Use various utilities
      LoggingUtils.info('Starting auto-workflow test');
      LoggingUtils.nativeInfo('Native operation');

      final now = DateTime.now();
      final timeFormatted = FormatUtils.formatTimeChineseSeparated(now);
      LoggingUtils.debug('Time formatted: $timeFormatted');

      NetworkUtils.setBearerToken('workflow_token');
      LoggingUtils.info('Network configured');
      NetworkUtils.clearBearerToken();

      LoggingUtils.info('Auto-workflow test completed');
      expect(true, isTrue);
    });

    test('Reset and re-initialization test', () {
      // Initialize
      EggyByteCore.initialize();
      expect(EggyByteCore.isInitialized, true);
      final firstPlatform = EggyByteCore.getTargetPlatform();

      // Reset
      EggyByteCore.reset();
      expect(EggyByteCore.isInitialized, false);
      expect(EggyByteCore.getTargetPlatform(), null);

      // Re-initialize
      EggyByteCore.initialize();
      expect(EggyByteCore.isInitialized, true);
      final secondPlatform = EggyByteCore.getTargetPlatform();

      // Platform should be the same after re-initialization
      expect(secondPlatform, firstPlatform);
    });

    test('Custom logging configuration after initialization', () {
      EggyByteCore.initialize();

      // Should be able to reconfigure logging after initialization
      expect(
          () => EggyByteCore.configureLogging(
              enableColors: false, enableBold: false),
          returnsNormally);

      // Logging should still work
      expect(() => LoggingUtils.info('Reconfiguration test'), returnsNormally);
    });
  });
}
