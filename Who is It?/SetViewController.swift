//
//  SetViewController.swift
//  Who is It?
//
//  Created by Jakub Górka on 21/08/2023.
//

import SwiftUI
import UIKit

struct SetViewController: View {
    
//    @StateObject var personsStorageManager = PersonsStorageManager()
    
    @ObservedObject var system: System
    @ObservedObject var gameSet: GameSet
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var view: ViewController


    var body: some View {
        Group {
            ZStack{
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    // Landscape mode
                    EditView(system: system, view: view, gameSet: gameSet)
                } else {
                    // Portrait mode or other cases
                    GameView(gameSet: gameSet)
                }
                HelpView()
            }
        }
    }
}
