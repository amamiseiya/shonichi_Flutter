// 匹配中文/日文姓名（“汉字+空格+汉字”的文本）
final characterNameRegExp = RegExp(
    r'[\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u4e00-\u9fa5]+ [\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u4e00-\u9fa5]+');
// 匹配汉字
final chineseCharRegExp = RegExp(r'[\u4e00-\u9fa5]');
// 将中文/日文名简写为姓名
final characterNameFirstNameRegExp = RegExp(r'(?<= ).+');

// Duration简写
final simpleDurationRegExp = RegExp(r'\d:\d\d\.\d\d\d');

final mdTitleRegExp = RegExp(r'# \S+\n');
final storyboardChapterRegExp =
    RegExp(r'(?<=# 分镜表\n).+(?!# \S+\n)', dotAll: true);

// print\('.*\.'\); //用于匹配以句号结尾的print
