import 'package:leancloud_storage/leancloud.dart';
import 'package:test/test.dart';

import '../lib/main.dart';

void main(List<String> args) {
  test('', () async {
    LCObject object = LCObject('TestObject');
    object['words'] = 'Hello world!';
    await object.save();
  });
}
