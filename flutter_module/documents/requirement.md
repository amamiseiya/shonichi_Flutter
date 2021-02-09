# 文档

## 需求描述

1. 用户打开App之后，可以进行账号注册，或是用已有账号进行登录。
2. 首次使用App时，App将跳转至引导教程页面，引导用户完成初始数据的添加工作。
3. 登录后，用户可以查看所有项目(Project)数据，并可进行创建、修改、删除操作。用户可以指定一个项目为当前进行项目，指定后可以在后续分支页面进行详细编辑。
4. 用户进入分镜编辑页面后，可以查看所有分镜表(ShotTable)数据，并可进行创建、修改、删除操作。用户可以指定一个分镜表为当前使用分镜表，指定后可以进行分镜(Shot)的编辑。
5. 用户在编辑分镜时，软件可以根据现有的歌曲、队形、分镜等信息，为用户进行智能推荐，自动填充数据。
6. 用户进入队形编辑页面后，可以查看所有队形列表(FormationTable)数据，并可进行创建、修改、删除操作。用户可以指定一个队形列表为当前使用队形列表，指定后可以进行队形(Formation)的编辑。
7. 用户进入歌曲详情页面后，可以查看当前歌曲的歌词(Lyric)数据。用户可通过lrc文件批量导入歌词数据。
8. 用户进入歌曲管理页面后，可以查看所有歌曲(Song)数据，并可进行创建、修改、删除操作。
9. 用户进入数据迁移页面后，可以从JSON导入数据，将当前数据导出为Markdown。

## 用例图

``` plantuml
@startuml 用户与移动设备交互用例图

User -> (登录)
User -> (注册)
(注册) -> (登录)
(登录) -> (编辑Project)
(登录) -up-> (修改个人信息)
(编辑Project) -> (选择Project)
(编辑Project) -up-> (创建Project)
(编辑Project) -up-> (修改Project)
(编辑Project) -up-> (删除Project)
(选择Project) --> (编辑Shot)
(选择Project) --> (编辑Song)
(选择Project) --> (编辑Formation)
(选择Project) --> (数据迁移)
(数据迁移) --> (从JSON导入)
(数据迁移) --> (导出为Markdown)

@enduml
```

## 类图

``` plantuml
@startuml Class

SNProject "1..*" -- "1" SNSong
SNProject "1..*" -- "1" SNShotTable
SNProject "1..*" -- "1" SNFormationTable
SNSong "1" -- "1..*" SNShotTable
SNSong "1" -- "1..*" SNFormationTable
SNSong "1" *-- "1..*" SNLyric
SNShotTable "1" *-- "1..*" SNShot
SNFormationTable "1" *-- "1..*" SNFormation

class SNProject {

    String id
    String dancerName
    DateTime createdTime
    DateTime modifiedTime
    String songId
    String shotTableId
    String formationTableId
    fromMap()
    toMap()

}

class SNSong {

    String id
    String name
    String coverFileName
    int lyricOffset
    String subordinateKikaku
    fromMap()
    toMap()

}

class SNLyric {

    String id
    Duration startTime
    Duration endTime
    String text
    String songId
    List<SNCharacter> soloPart
    fromMap()
    toMap()

}

class SNShotTable {
  String id
  String name
  String authorId
  String songId
  fromMap()
  toMap()
}

class SNShot {

    String id
    int sceneNumber
    int shotNumber
    Duration startTime
    Duration endTime
    String lyric
    String shotType
    String shotMovement
    String shotAngle
    String text
    String image
    String comment
    String tableId
    List<SNCharacter> characters
    fromMap()
    toMap()

}
class SNFormationTable {
  String id
  String name
  String authorId
  String songId

  fromMap()
  toMap()
}

class SNFormation {

    String id
    Duration startTime
    double posX
    double posY
    int curveX1X
    int curveX1Y
    int curveX2X
    int curveX2Y
    int curveY1X
    int curveY1Y
    int curveY2X
    int curveY2Y
    String characterName
    String tableId
    fromMap()
    toMap()

}

@enduml
```

## 状态图（以Project编辑页面为例）

``` plantuml
@startuml HomePageState

[*] --> ProjectUninitialized
ProjectUninitialized --> RetrievingProject: InitializeApp
RetrievingProject --> NoProjectRetrieved
RetrievingProject --> ProjectRetrieved
NoProjectRetrieved --> CreatingProject: CreateProject
ProjectRetrieved --> CreatingProject: CreateProject
ProjectRetrieved --> RetrievingProject: DeleteProject
CreatingProject --> RetrievingProject: SubmitCreateProject
ProjectRetrieved --> [*]

@enduml
```
