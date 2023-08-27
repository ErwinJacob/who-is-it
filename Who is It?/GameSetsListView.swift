//
//  GameSetsListView.swift
//  Who is It?
//
//  Created by Jakub Górka on 21/08/2023.
//

import SwiftUI

struct GameSetsListView: View {
    
    @ObservedObject var system: System
    @ObservedObject var view: ViewController
    
    @State var searchedId: String = ""
    @State var showSearchSetAlert: Bool = false
    
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                ScrollView{
                    ForEach(system.sets){ set in
                        
                        Button {
                            view.setView(set: set)
                        } label: {
                            GameSetsLabelView(gameSet: set)
                        }
                        .frame(width: proxy.size.width*0.85, height: proxy.size.height*0.15)
                        
                        
                        
                    }
                    
                    Button {
//                        Task{
                            //TODO: IMPORT SET
//                            await system.createNewSet(setName: "New game set")
//                            if searchedId != ""{
//                                await system.findSetByShortenedId(shortenedId: ""){ foundSet in
//                                    system.sets.append(foundSet)
//                                }
//                            }
//                        }
                        showSearchSetAlert = true
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.primary)
                                .opacity(0.15)
                            VStack{
                                Image(systemName: "square.and.arrow.down")
                                    .resizable()
                                    .frame(width: proxy.size.height*0.035, height: proxy.size.height*0.035)
                                Text("Import Set")
                                    .font(.title3)
                                    .bold()
                            }
                            .foregroundColor(Color.primary)
                        }
                    }
                    .frame(width: proxy.size.width*0.85, height: proxy.size.height*0.15)
                    .alert("Import set", isPresented: $showSearchSetAlert) {
                        TextField("Enter set ID", text: $searchedId)
                        Text("")
                        Button("OK", action: {
                            Task{
                                if searchedId != ""{
                                    await system.findSetByShortenedId(shortenedId: searchedId){ foundSet in
                                        system.sets.append(foundSet)
                                        system.saveSets()
                                    }
                                }
                            }
                        })
                    } message: {
                        Text("Just enter the first few symbols.")
                    }

                    
                    Button {
                        Task{
                            await system.createNewSet(setName: "New game set")
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.primary)
                                .opacity(0.15)
                            VStack{
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: proxy.size.height*0.035, height: proxy.size.height*0.035)
                                Text("Create new set")
                                    .font(.title3)
                                    .bold()
                            }
                            .foregroundColor(Color.primary)
                        }
                    }
                    .frame(width: proxy.size.width*0.85, height: proxy.size.height*0.15)
                    
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height*0.85)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}


struct GameSetsLabelView: View {
        
    @ObservedObject var gameSet: GameSet
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.primary)
                .opacity(0.15)
            VStack{
                Text(gameSet.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.primary)
                
                Text(gameSet.id)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
    }
}
