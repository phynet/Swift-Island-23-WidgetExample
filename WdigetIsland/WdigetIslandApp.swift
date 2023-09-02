//
//  WdigetIslandApp.swift
//  WdigetIsland
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import SwiftUI

@main
struct WdigetIslandApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .defaultAppStorage(UserDefaults(suiteName: groupName)!)
        }
    }
}
