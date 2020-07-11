//
//  ContentView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/6/30.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DashboardView(projectViewModel: ProjectViewModel())
//        }
//    }
//}

struct DashboardView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var projectViewModel: ProjectViewModel
    @State private var popoverAddIsShowing: Bool = false
    @FetchRequest var allProjectsResults: FetchedResults<SNProject>
    
    init(projectViewModel: ProjectViewModel) {
        self.projectViewModel = projectViewModel
        self._allProjectsResults = FetchRequest(fetchRequest: projectViewModel.allProjectsRequest)
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("お帰りなさい♪")
                LatestProjectView
                List {
                    if allProjectsResults.count > 1 {
                        ForEach(self.allProjectsResults) { project in
                            NormalProjectView(project: project)
                        }.onDelete { indexSet in indexSet.map {
                            self.allProjectsResults[$0]
                        }.forEach{ self.projectViewModel.deleteProject(project: $0) }
                        }
                    }
                }.padding(.all, 15.0)
                List {
                    NavigationLink(destination: ShotEditorView(shotViewModel: ShotViewModel(context: context, projectViewModel: projectViewModel))) {
                        Text("分镜脚本编辑")
                    }
                    NavigationLink(destination: SongEditorView(songViewModel: SongViewModel(context: context, projectViewModel: projectViewModel))) {
                        Text("歌曲信息查看")
                    }
                    NavigationLink(destination: FormationEditorView(formationViewModel: FormationViewModel(context: context, projectViewModel: projectViewModel))) {
                        Text("队形编辑")
                    }
                }
            }.navigationBarItems(trailing: HStack {
                Button(action:{}){Image(systemName: "arrow.clockwise").imageScale(.large)}.fixedSize()
                Button(action:{self.popoverAddIsShowing = true}){Image(systemName: "plus").imageScale(.large)}.fixedSize()
                    .popover(isPresented: $popoverAddIsShowing) { popoverEdit(projectViewModel: self.projectViewModel, isShowing: self.$popoverAddIsShowing).environment(\.managedObjectContext, self.context)
                }
        })
    }
}
    
    var LatestProjectView: some View {
        return Group {
            Button(action:{}){
                if !self.allProjectsResults.isEmpty {
                    Text("当前项目：")
                    Text(allProjectsResults.first!.aggregatesSong?.name ?? "未知曲目 with \(allProjectsResults.first!.dancerName!)")
                Spacer()
                } else {
                    Text("当前没有项目。")
                }
            }
        }
    }
    
    struct NormalProjectView: View {
        
        var project: SNProject
        
        var body: some View {
            VStack(alignment: .leading) {
                       Text(project.aggregatesSong?.name ?? "未知曲目 with \(project.dancerName!)")
                       Text("创建时间：")
                       Text(project.createdTime!.description)
            }
        }
    }
}


        
struct popoverEdit: View {
    var projectViewModel: ProjectViewModel
    @Environment(\.managedObjectContext) var context
    @Binding var isShowing: Bool
    
    @State private var dancerName: String = ""
    
    init(project: SNProject?) {
        if project != nil {
            self.dancerName = project!.dancerName!
        }
    }
       
    var body: some View {
        NavigationView {
           Form {
               TextField("Dancer Name", text: $dancerName)
           }.navigationBarItems(leading: Button(action: {self.isShowing = false}){ Text("Cancel")}, trailing: Button(action: {
            if !self.dancerName.isEmpty {
                self.projectViewModel.addProject(dancerName: self.dancerName)
                self.isShowing = false
            }
           }) { Text("Done")})
       }
    }
}
