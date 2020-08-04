//
//  ShotViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class ShotViewModel: ObservableObject {
    var context: NSManagedObjectContext
    @ObservedObject var projectViewModel: ProjectViewModel
    
    var currentShotTable: SNShotTable? {
        projectViewModel.currentProject?.aggregatesShotTable
    }
    
    var allShotTablesForSongRequest: NSFetchRequest<SNShotTable> {
        let allShotTablesForSongRequest = NSFetchRequest<SNShotTable>(entityName: "SNShotTable")
        allShotTablesForSongRequest.predicate = NSPredicate(format: "madeFor = %@", argumentArray: [projectViewModel.currentProject?.aggregatesSong])
        allShotTablesForSongRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allShotTablesForSongRequest
    }
    
    var allShotsForProjectRequest: NSFetchRequest<SNShot> {
        let allShotsForProjectRequest = NSFetchRequest<SNShot>(entityName: "SNShot")
        allShotsForProjectRequest.predicate = NSPredicate(format: "compositedBy = %@", argumentArray: [currentShotTable])
        allShotsForProjectRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        return allShotsForProjectRequest
    }
    
    init(context: NSManagedObjectContext, projectViewModel: ProjectViewModel) {
        self.context = context
        self.projectViewModel = projectViewModel
    }
    
    func addShotTable(name: String, author: String, aggregatedBy: NSSet?, madeFor: SNSong?) -> SNShotTable {
        let shotTable = SNShotTable(context: self.context)
        shotTable.id = UUID()
        shotTable.name = name
        shotTable.author = author
        
//        if aggregatedBy != nil {
//            shotTable.addToAggregatedBy(aggregatedBy!)
//        } else {
//            print("Error")
//        }
        
        shotTable.aggregatedBy = aggregatedBy
        shotTable.madeFor = madeFor
        
        try? self.context.save()
        return shotTable
    }
    
    func updateShotTable(shotTable: SNShotTable) -> Void {
    }
    
    func deleteShotTable(shotTable: SNShotTable) -> Void {
        context.delete(shotTable)
        try? self.context.save()
    }
    
    func selectCurrentShotTable(currentShotTable: SNShotTable?) -> Void {
        if self.projectViewModel.currentProject?.aggregatesShotTable == currentShotTable {
            self.projectViewModel.currentProject?.aggregatesShotTable = nil
            print("currentShotTable unselected.")
        } else {
            self.projectViewModel.currentProject?.aggregatesShotTable = currentShotTable
            print("currentShotTable selected.")
        }
    }
    
    func addShot() -> SNShot? {
        if currentShotTable != nil {
            let shot = SNShot(context: self.context)
            shot.id = UUID()
            shot.startTime = Date()
            shot.compositedBy = currentShotTable
            try? self.context.save()
            return shot
        } else {
            return nil
        }
    }
    
    func deleteShot(shot: SNShot) -> Void {
        context.delete(shot)
        try? context.save()
    }
    
}
