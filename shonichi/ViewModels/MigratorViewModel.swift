//
//  MigratorViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/8/19.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class MigratorViewModel: ObservableObject {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
}

