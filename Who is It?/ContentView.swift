//
//  ContentView.swift
//  who is it
//
//  Created by Jakub Górka on 22/05/2023.
//

import SwiftUI


struct ContentView: View {

    @ObservedObject var system: System = System()
    @ObservedObject var view: ViewController = ViewController()
    
    var body: some View {
        switch view.view{
        case Views.listView:
            GameSetsListView(system: system, view: view)
        case Views.setView:
            SetViewController(system: system, gameSet: view.set!, view: view)
        }
    }
}



