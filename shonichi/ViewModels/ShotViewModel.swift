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
    
    var allShotsForProjectRequest: NSFetchRequest<SNShot> {
        let allShotsForProjectRequest = NSFetchRequest<SNShot>(entityName: "SNShot")
        allShotsForProjectRequest.predicate = NSPredicate(format: "compositedBy = %@", argumentArray: [projectViewModel.currentProject?.aggregatesShotTable])
        allShotsForProjectRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        return allShotsForProjectRequest
    }
    
    init(context: NSManagedObjectContext, projectViewModel: ProjectViewModel) {
        self.context = context
        self.projectViewModel = projectViewModel
    }
    
    
    
}
