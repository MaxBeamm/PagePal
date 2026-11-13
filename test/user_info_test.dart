import 'package:flutter_test/flutter_test.dart';
import 'package:cis400_final/UserInfo.dart' as app_user;

void main() {
  test('signed-in state can be set and cleared', () {
    final user = app_user.UserInfo();
    expect(user.getSignedIn(), isFalse);
    user.setSignedIn(true);
    expect(user.getSignedIn(), isTrue);
    user.signedOut();
    expect(user.getSignedIn(), isFalse);
    expect(user.firstName, 'Guest');
  });
}
