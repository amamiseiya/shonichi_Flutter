import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'Current project:': '当前项目：',
          'Input project ID:': '您也可以自行输入项目ID：',
          'Or another project:': '或是选择另一项目：',
          'Home Page': '首页',
          'Submit': '完成',
          'Welcome back!': '欢迎回来！',
        },
        'ja_CN': {
          'Current project:': '現在のプロジェクト：',
          'Input project ID:': 'プロジェクトの番号を入力：',
          'Or another project:': 'ほかのプロジェクト：',
          'Home Page': 'ホームページ',
          'Submit': '完了',
          'Welcome back!': 'お帰りなさい♪',
        }
      };
}
