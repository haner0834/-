//
//  ______App.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI
import TipKit

@main
struct ______App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GlobalViewModel())
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
