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
    
    var currentStoryboard: SNStoryboard? {
        projectViewModel.currentProject?.aggregatesStoryboard
    }
    
    // TODO: 实现正确的筛选
    var allStoryboardsForSongRequest: NSFetchRequest<SNStoryboard> {
        let allStoryboardsForSongRequest = NSFetchRequest<SNStoryboard>(entityName: "SNStoryboard")
        allStoryboardsForSongRequest.predicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: [projectViewModel.currentProject?.aggregatesSong])
        allStoryboardsForSongRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allStoryboardsForSongRequest
    }
    
    var allShotsForProjectRequest: NSFetchRequest<SNShot> {
        let allShotsForProjectRequest = NSFetchRequest<SNShot>(entityName: "SNShot")
        allShotsForProjectRequest.predicate = NSPredicate(format: "compositedBy = %@", argumentArray: [currentStoryboard])
        allShotsForProjectRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        return allShotsForProjectRequest
    }
    
    init(context: NSManagedObjectContext, projectViewModel: ProjectViewModel) {
        self.context = context
        self.projectViewModel = projectViewModel
    }
    
    func addStoryboard(name: String, author: String, aggregatedBy: NSSet?, madeFor: SNSong?) -> SNStoryboard {
        let storyboard = SNStoryboard(context: self.context)
        storyboard.id = UUID()
        storyboard.name = name
        storyboard.author = author
        
//        if aggregatedBy != nil {
//            storyboard.addToAggregatedBy(aggregatedBy!)
//        } else {
//            print("Error")
//        }
        
        storyboard.aggregatedBy = aggregatedBy
        storyboard.madeFor = madeFor
        
        try? self.context.save()
        print("New shottable added.")
        return storyboard
    }
    
    func updateStoryboard(storyboard: SNStoryboard) -> Void {
    }
    
    func deleteStoryboard(storyboard: SNStoryboard) -> Void {
        context.delete(storyboard)
        try? self.context.save()
    }
    
    func selectCurrentStoryboard(currentStoryboard: SNStoryboard?) -> Void {
        if self.projectViewModel.currentProject?.aggregatesStoryboard == currentStoryboard {
            self.projectViewModel.currentProject?.aggregatesStoryboard = nil
            print("currentStoryboard unselected.")
        } else {
            self.projectViewModel.currentProject?.aggregatesStoryboard = currentStoryboard
            print("currentStoryboard selected.")
        }
    }
    
    func addShot() -> SNShot? {
        if currentStoryboard != nil {
            let shot = SNShot(context: self.context)
            shot.id = UUID()
            shot.startTime = Date()
            shot.compositedBy = currentStoryboard
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
