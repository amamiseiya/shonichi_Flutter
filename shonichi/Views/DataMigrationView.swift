//
//  MigratorView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/8/19.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI

struct MigratorView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var migratorViewModel: MigratorViewModel
    
    init(migratorViewModel: MigratorViewModel) {
        self.migratorViewModel = migratorViewModel
    }
    
    var body: some View {
        NavigationView {
            Text("")
            .navigationBarTitle("")
            .navigationBarItems(trailing: Button(action: {}){Image(systemName: "plus").imageScale(.large)}.fixedSize())
        }
    }
}
