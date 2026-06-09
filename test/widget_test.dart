import 'package:flutter_test/flutter_test.dart';
import 'package:lije/app/shell/main_shell.dart';
import 'package:lije/features/splash/ui/splash_screen.dart';
import 'package:lije/main.dart';

void main() {
  testWidgets('App shows splash then main shell', (WidgetTester tester) async {
    await tester.pumpWidget(const LijeApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MainShell), findsOneWidget);

    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
  });
}
