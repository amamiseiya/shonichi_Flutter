final characterNameRegExp = RegExp(
    r'[\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u4e00-\u9fa5]+ [\u3040-\u309F\u30A0-\u30FF\u31F0-\u31FF\u4e00-\u9fa5]+');
final chineseCharRegExp = RegExp(r'[\u4e00-\u9fa5]');
final simpleDurationRegExp = RegExp(r'\d:\d\d\.\d\d\d');

final mdTitleRegExp = RegExp(r'# \S+\n');
final storyboardChapterRegExp =
    RegExp(r'(?<=# 分镜表\n).+(?!# \S+\n)', dotAll: true);
