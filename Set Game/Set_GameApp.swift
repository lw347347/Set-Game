//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Landon Williams on 9/17/21.
//

import SwiftUI

@main
struct Set_GameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(setGameViewModel: SetGameViewModel())
        }
    }
}
