//
//  SongEditorView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct SongEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongEditorView()
//    }
//}


struct SongEditorView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var songViewModel: SongViewModel
    @State private var popoverAddIsShowing: Bool = false
    @FetchRequest var allSongsResults: FetchedResults<SNSong>
    
    init(songViewModel: SongViewModel) {
        self.songViewModel = songViewModel
        self._allSongsResults = FetchRequest(fetchRequest: songViewModel.allSongsRequest)
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(allSongsResults, id: \.id) { song in
                    SongItem(song: song)
                }
            }
        }
    }
}

struct SongItem: View {
    var song: SNSong

    var body: some View {
        HStack {
            Text(song.name!)
        }
    }
}
