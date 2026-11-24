import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const prefixKey = ValueKey('prefix');
  const suffixKey = ValueKey('suffix');
  const prefix = SizedBox(key: prefixKey, width: 14, height: 14);
  const suffix = SizedBox(key: suffixKey, width: 14, height: 14);

  testWidgets('centers leading and trailing widgets in a single-line field',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 42,
          child: BaseTextField(
            borderRadius: 4,
            prefix: prefix,
            suffix: suffix,
          ),
        ),
      ),
    ));

    final fieldCenter = tester.getCenter(find.byType(BaseTextField)).dy;
    expect(tester.getCenter(find.byKey(prefixKey)).dy, fieldCenter);
    expect(tester.getCenter(find.byKey(suffixKey)).dy, fieldCenter);
  });

  testWidgets('top-aligns leading and trailing widgets in a multiline field',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: BaseTextField(
          borderRadius: 4,
          maxLines: 3,
          prefix: prefix,
          suffix: suffix,
        ),
      ),
    ));

    final textTop = tester.getTopLeft(find.byType(TextField)).dy;
    expect(tester.getTopLeft(find.byKey(prefixKey)).dy, textTop);
    expect(tester.getTopLeft(find.byKey(suffixKey)).dy, textTop);
  });
}
