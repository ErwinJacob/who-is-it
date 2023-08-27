//
//  Who_is_It_App.swift
//  Who is It?
//
//  Created by Jakub Górka on 20/08/2023.
//

import SwiftUI
import Firebase

@main
struct Who_is_It_App: App {
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
