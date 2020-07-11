//
//  ShotModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI

//// Deprecated
//struct SNShot: Identifiable {
//
//    var id: Int
//    var shotTableId: Int
//    var shotName: String
//    var startTime: Date
//    var endTime: Date
//    var sceneNumber: Int
//    var shotNumber: Int
//    var lyric: String
//    var characters: [SNCharacter]
//    var type: ShotType
//    var movement: ShotMovement
//    var angle: ShotAngle
//    var content: String
//    var image: UIImage
//    var comment: String
//
//}

enum ShotType{
    case closeUp
    case mediumCloseUp
    case mediumShot
    case longShot
    case veryLongShot
}

enum ShotMovement{
    case closeUp
    case mediumCloseUp
    case mediumShot
    case longShot
    case veryLongShot
}

enum ShotAngle{
    case closeUp
    case mediumCloseUp
    case mediumShot
    case longShot
    case veryLongShot
}
