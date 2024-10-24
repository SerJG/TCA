//
//  BookPlayerApp.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 23.10.2024.
//

import SwiftUI

@main
struct BookPlayerApp: App {
    var body: some Scene {
        
        WindowGroup {
            LibraryView(store: .init(initialState: .init(), reducer: {
                LibraryReducer()
            }))
        }
    }
}
