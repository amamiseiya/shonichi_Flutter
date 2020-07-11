//
//  ProjectViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class ProjectViewModel: ObservableObject {
    
    var context: NSManagedObjectContext
//    var allProjects: [SNProject]?
    var currentProject: SNProject?
    
    var allProjectsRequest: NSFetchRequest<SNProject> {
        let allProjectsRequest = NSFetchRequest<SNProject>(entityName: "SNProject")
        allProjectsRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
        allProjectsRequest.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false)]
        return allProjectsRequest
    }

    init(context: NSManagedObjectContext) {
        self.context = context
//        fetchAllProjects()
    }
    
//    func fetchAllProjects() -> Void {
//
//        try? allProjects = self.context.fetch(allProjectsRequest)
//    }
    
    
    // MARK: Intent

    func addProject(dancerName: String) -> Void {
        let project = SNProject(context: self.context)
        project.id = UUID()
        project.dancerName = dancerName
        project.createdTime = Date()
        
        try? self.context.save()
        
    }
    
    func updateProject(project: SNProject) -> Void {

    }
    
    func deleteProject(project: SNProject) -> Void {
        context.delete(project)
        try? context.save()
    }

    func selectCurrentProject(currentProject: SNProject) -> Void {
        self.currentProject = currentProject
    }
}
