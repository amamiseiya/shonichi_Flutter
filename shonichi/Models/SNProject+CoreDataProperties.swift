//
//  SNProject+CoreDataProperties.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/8/14.
//  Copyright © 2020 seiya studio. All rights reserved.
//
//

import Foundation
import CoreData



extension SNProject: Identifiable {
    
}


extension SNProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SNProject> {
        return NSFetchRequest<SNProject>(entityName: "SNProject")
    }

    @NSManaged public var createdTime: Date?
    @NSManaged public var dancerName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var modifiedTime: Date?
    @NSManaged public var aggregatesFormationTable: SNFormationTable?
    @NSManaged public var aggregatesShotTable: SNShotTable?
    @NSManaged public var aggregatesSong: SNSong?

}
