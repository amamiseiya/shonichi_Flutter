//
//  SNStoryboard+CoreDataProperties.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/8/14.
//  Copyright © 2020 seiya studio. All rights reserved.
//
//

import Foundation
import CoreData

extension SNStoryboard: Identifiable {

}


//extension SNShot: Identifiable {
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


extension SNStoryboard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SNStoryboard> {
        return NSFetchRequest<SNStoryboard>(entityName: "SNStoryboard")
    }

    @NSManaged public var author: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var aggregatedBy: NSSet?
    @NSManaged public var composites: NSSet?
    @NSManaged public var madeFor: SNSong?

}

// MARK: Generated accessors for aggregatedBy
extension SNStoryboard {

    @objc(addAggregatedByObject:)
    @NSManaged public func addToAggregatedBy(_ value: SNProject)

    @objc(removeAggregatedByObject:)
    @NSManaged public func removeFromAggregatedBy(_ value: SNProject)

    @objc(addAggregatedBy:)
    @NSManaged public func addToAggregatedBy(_ values: NSSet)

    @objc(removeAggregatedBy:)
    @NSManaged public func removeFromAggregatedBy(_ values: NSSet)

}

// MARK: Generated accessors for composites
extension SNStoryboard {

    @objc(addCompositesObject:)
    @NSManaged public func addToComposites(_ value: SNShot)

    @objc(removeCompositesObject:)
    @NSManaged public func removeFromComposites(_ value: SNShot)

    @objc(addComposites:)
    @NSManaged public func addToComposites(_ values: NSSet)

    @objc(removeComposites:)
    @NSManaged public func removeFromComposites(_ values: NSSet)

}
