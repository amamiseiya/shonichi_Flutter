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
    @State private var editSheetIsShowing: Bool = false
    @FetchRequest var allSongsResults: FetchedResults<SNSong>
    @FetchRequest var allLyricsForSongResults: FetchedResults<SNLyric>
    
    init(songViewModel: SongViewModel) {
        self.songViewModel = songViewModel
        self._allSongsResults = FetchRequest(fetchRequest: songViewModel.allSongsRequest)
        self._allLyricsForSongResults = FetchRequest(fetchRequest: songViewModel.allLyricsForSongRequest)
    }
    
    var body: some View {
        NavigationView{
            songList
                .sheet(isPresented: $editSheetIsShowing, content: {EditSongSheet(songViewModel: self.songViewModel, isShowing: self.$editSheetIsShowing)})
                .navigationBarItems(trailing: Button(action: {self.editSheetIsShowing = true}, label: {Image(systemName: "plus")}))
            Divider()
            lyricList
            
        }
    }
    
    var songList: some View {
        List{
            ForEach(allSongsResults) { song in
                SongItem(song: song)
        }.onDelete { indexSet in indexSet.map {
            self.allSongsResults[$0]
            }.forEach{ self.songViewModel.deleteSong(song: $0)
            }
        }
        }
    }
    
    var lyricList: some View {
        List{
            ForEach(allLyricsForSongResults) { lyric in
                LyricItem(lyric: lyric)
        }.onDelete { indexSet in indexSet.map {
            self.allLyricsForSongResults[$0]
            }.forEach{ self.songViewModel.deleteLyric(lyric: $0)
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

struct LyricItem: View {
    var lyric: SNLyric

    var body: some View {
        HStack {
            Text(lyric.text!)
        }
    }
}

struct EditSongSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var songViewModel: SongViewModel
    @Binding var isShowing: Bool
    
    @State private var name: String = ""
    @State private var coverFile: UIImage?
    
    init(songViewModel: SongViewModel, isShowing: Binding<Bool>) {
        self.songViewModel = songViewModel
        self._isShowing = isShowing
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Properties")) {
                    TextField("Song Name", text: $name)
                    NavigationLink(destination: SongCoverPicker(sourceType: .photoLibrary, onImagePicked: { image in
                        self.coverFile = image
                        self.presentationMode.wrappedValue.dismiss()
                    }, onCancelled: {
                        self.presentationMode.wrappedValue.dismiss()
                    }), label: {Text("Select cover from library:")})
                }
            }.navigationBarItems(trailing: Button(action: {
                                if !self.name.isEmpty {
                                    let newSong = self.songViewModel.addSong(name: self.name)
            //                        newSong.coverFile = coverFile
                                    self.isShowing = false
                                }
                            }) { Text("Done")})
        }
    }
}


struct SongCoverPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage?) -> Void
    var onCancelled: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked, onCancelled: onCancelled)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var onImagePicked: (UIImage?) -> Void
        var onCancelled: () -> Void
        
        init(onImagePicked: @escaping (UIImage?) -> Void, onCancelled: @escaping () -> Void){
            self.onImagePicked = onImagePicked
            self.onCancelled = onCancelled
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            onImagePicked(info[.originalImage] as? UIImage)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancelled()
        }
    }
}
