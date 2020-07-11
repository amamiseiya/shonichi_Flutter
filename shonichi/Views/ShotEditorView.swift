//
//  ShotEditorView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct ShotEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShotEditorView()
//    }
//}


struct ShotEditorView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var shotViewModel: ShotViewModel
    @State private var popoverAddIsShowing: Bool = false
    @FetchRequest var allShotsForProjectResults: FetchedResults<SNShot>
    
    init(shotViewModel: ShotViewModel) {
        self.shotViewModel = shotViewModel
        self._allShotsForProjectResults = FetchRequest(fetchRequest: shotViewModel.allShotsForProjectRequest)
    }
    
    var body: some View {
        NavigationView{
            List {
                ForEach(self.allShotsForProjectResults, id: \.id ) { shot in
                    ShotItem(shot: shot)
                }
            }
        }
    }
}

struct ShotItem: View {
    var shot: SNShot
    
    var body: some View {
        HStack {
            Text(shot.startTime!.description)
            Text(shot.lyric!)
        }
    }
}
