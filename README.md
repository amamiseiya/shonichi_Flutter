# shonichi

しょにち。初日。
一个辅助宅舞拍摄的App。
使用Flutter为混合开发框架，集成Firebase云服务。
本项目尚未开发完成，代码和文档都很辣鸡，不建议Star&Fork。

这是一个 **“专用”** 的App。其“专用”，体现在其主要用来辅助 **LoveLive、AKB48等偶像企划** 的 **宅舞的录制** ，且仅用于满足 **本作者** 的实际需求。
本作者无意也没有条件，将其发展为一个大范围公开的、通用的应用。

## 功能简介

目前为止，本App提供了在拍摄前准备阶段需要用到的一系列功能。
包括项目选择、分镜脚本编辑、歌曲信息查看、舞蹈队型编辑、文档导出。

### 首页-项目选择

![HomePage-w400](/flutter_module/documents/images/HomePage.png)

HomePage
在该页面下，您可以选择当前进行的项目，或是增加、修改、删除某一项目。

点击添加按钮，或选定某一项目后点击修改按钮，App将弹出对话框，用于修改项目信息。

![Homepage-Add-w200](/flutter_module/documents/images/Homepage-Add.png)

### 分镜脚本编辑

![ShotEditorPage-w400](/flutter_module/documents/images/ShotEditorPage.png)

ShotEditorPage
在该页面下，您可以进行分镜脚本的编辑工作。

左侧的表单中的内容为本项目中的所有分镜。每一条分镜记录包含以下字段：镜号、起始时间、歌词内容、场号、角色、景别、运动、角度、拍摄内容、画面、备注。
其中部分字段可以通过输入框或选择菜单来修改。进行的更改会实时保存。

右侧的检视器为当前分镜脚本的一些信息。
顶部是当前企划的名称。
其下是当前各个成员的拍摄镜头的数量。您可以根据这部分数据，合理安排镜头，保证所有被拍对象都有适当的出镜机会。
底部是歌词覆盖情况。当分镜的起始时间与某一歌词相同时，该歌词将被高亮显示，代表有分镜“覆盖”了这一句歌词。您可以据此大概了解分镜脚本的完成度。

### 歌曲信息查看

![SongInfoPage-w400](/flutter_module/documents/images/SongInfoPage.png)

SongInfoPage
在该页面下，您可以查看当前项目使用的歌曲的详细信息。

左侧的表单中的内容为歌曲的全部歌词记录。
每一条歌词记录，有开始时间、歌词内容、Solo Part字段。
Solo Part……很难解释，不过你应该懂的吧，就是这一句该谁Solo了。
目前该字段需要您人工填写。该字段可以为分镜的设计提供参考。

右边的检视器为针对整个歌曲的一些信息。
顶部是当前企划的名称。
（待完善）其下为视频播放器，与歌曲相关的视频将在此播放，如官方PV、舞蹈教学等。

### 舞蹈队形编辑

![MovementEditorPage-w400](/flutter_module/documents/images/MovementEditorPage.png)

MovementEditorPage
在该页面下，您可以进行当前项目的舞蹈队形的编辑。

页面顶部为歌曲进度滑条。滑动以调整时间。
其下为角色选择按钮。其列出了当前项目的所有角色。
页面中间为当前时间下的队形情况预览，即所有角色的所处位置。
队形预览的左下方为关键帧曲线编辑。在此调整位置移动的关键帧曲线，与MMD的操作相似。
右下方为曲线选择按钮。在此选择针对哪条曲线进行编辑。
右侧为关键帧列表，显示了当前项目的所有关键帧。如果指定了时间或是角色，显示内容将根据您的选择被过滤。

通过滑动条选择某一时间，并选定某一角色后，点击添加按钮，将为该时间该角色创建一个关键帧。
在角色、时间、曲线类型全部选定的后，页面左下方将显示对应曲线。
您可以拖动左下方与右上方的锚点，来对曲线进行编辑。

### 所有歌曲查看

![SongListPage-w400](/flutter_module/documents/images/SongListPage.png)

SongListPage
在该页面下，您可以查看App中保存的所有歌曲的信息。

点击添加按钮，或点击列表中某一歌曲的标题，将弹出对话框，您可以在这里修改歌曲信息。

![SongListPage-Add-w200](/flutter_module/documents/images/SongListPage-Add.png)

### 文档导出

![MigratorPage-w400](/flutter_module/documents/images/MigratorPage.png)

MigratorPage
在该页面下，您可以将当前项目的分镜脚本等信息导出为Markdown文档。

点击生成按钮，将生成Markdown文档，在页面左边预览。
点击写入按钮来将文件导出至应用目录下。

![MigratorPage-MarkdownPreview-w400](/flutter_module/documents/images/MigratorPage-MarkdownPreview.png)

## Getting Started

### iOS下的配置

* 本地文件存储

``` plist
    <key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>
    <key>UIFileSharingEnabled</key>
    <true/>

```

### 初次使用

初次使用，本地数据库未建立时，启动App后将跳转至Tutorial页面。
您可以点击添加按钮，来新建一个项目。
或是通过预置的按钮，将整个数据库重置为默认的测试数据。

### 然后就根据功能介绍来使用吧

如题。

## 软件分析

### 文件结构

或许这能帮助您更好地了解这个项目？
只是或许。反正最开始，我是为了给我的大学作业凑字数，才写这部分内容的……

``` Dart

```

### 数据存储

本App集成了Google的Firebase套件，使用Firestore作为数据库。

### 文件存储

文件存储于Firebase Storage中。

* /images

歌曲封面
分镜图示

* /audios

歌曲

* /videos

官方PV

### 架构

本App最初使用BLoC为基础架构。虽然之后弃用了BLoC而使用GetX，基础架构仍然保持：

UI - BLoC - Model - Repository - Provider

* Repository

将Provider的数据处理为合适的Model，提供给Controller使用。

* Provider

提供数据。

## 一个真实的故事

* 2020年7月

发现两个艰难的事实：

1. Flutter还是不够我用的，我需要一个能够运行在iPhone、iPad、Apple Watch以及MacBook上、并且能在这些平台上进行交互的通用的应用，可能还需要集成Apple的ARKit等框架，用Flutter恐怕难以实现，必须原生开发。
2. 等等……Flutter是为了跨Apple之外的平台，可是我根本就不会在Android或是网页端上用它，我TM为什么闲得没事要用Flutter写啊？？！！

于是停止了Flutter项目的开发。转头学习iOS原生开发。希望重写现有功能，并继续改进。

* 2021年1月

发现iOS原生开发好难，还是用Flutter继续写吧……

## 参考

<https://leancloud.cn/docs/sdk_setup-flutter.html>

### 功能实现

#### 引导界面

使用flutter_intro package来实现。
