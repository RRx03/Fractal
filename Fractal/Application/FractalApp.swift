//
//  FractalApp.swift
//  Fractal
//
//  Created by Roman Roux on 17/09/2023.
//

import SwiftUI

@main
struct FractalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().frame(width: Preferences.windowWidth, height: Preferences.windowHeight, alignment: .center).fixedSize()
        }.windowResizability(.contentSize)
    }
}
