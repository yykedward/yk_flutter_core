import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yk_flutter_core/src/widgets/yk_click_widget.dart';
import 'package:yk_flutter_core/src/widgets/yk_future_widget.dart';
import 'package:yk_flutter_core/src/widgets/yk_empty_widget.dart';
import 'package:yk_flutter_core/src/widgets/yk_loading_widget.dart';
import 'package:yk_flutter_core/src/widgets/yk_text_widget.dart';

void _noop() {}

void main() {
  group('YkClickWidget', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: YkClickWidget(
            onTap: _noop,
            child: const Text('Click me'),
          ),
        ),
      );

      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('builds with needFilter=false without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: YkClickWidget(
            onTap: _noop,
            needFilter: false,
            child: const Text('No filter'),
          ),
        ),
      );

      expect(find.text('No filter'), findsOneWidget);
    });
  });

  group('YkFutureWidget', () {
    testWidgets('shows loadingWidget while future is pending', (tester) async {
      final completer = Completer<String>();

      await tester.pumpWidget(
        MaterialApp(
          home: YkFutureWidget<String>(
            initFuture: completer.future,
            widgetBuilder: (context, data) => Text(data),
            loadingWidget: const Text('loading...'),
            emptyWidget: const Text('empty'),
          ),
        ),
      );

      expect(find.text('loading...'), findsOneWidget);
    });

    testWidgets('shows data when future completes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: YkFutureWidget<String>(
            initFuture: Future.value('result'),
            widgetBuilder: (context, data) => Text(data),
            loadingWidget: const Text('loading...'),
            emptyWidget: const Text('empty'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('result'), findsOneWidget);
    });
  });

  group('YkEmptyWidget', () {
    testWidgets('renders empty state with text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: YkEmptyWidget(text: 'No data')),
      );

      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('renders without text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: YkEmptyWidget()),
      );

      expect(find.byIcon(Icons.layers_clear), findsOneWidget);
    });
  });

  group('YkLoadingWidget', () {
    testWidgets('renders loading indicator with text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: YkLoadingWidget(text: 'Loading...')),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('YkTextWidget', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: YkTextWidget('Hello World')),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });
  });
}
