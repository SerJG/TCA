//
//  PlaybackBar.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

struct PlaybackBar: View {
    
    @State private var currentTime: TimeInterval = 0
    let totalTime: TimeInterval
    
    var body: some View {
        HStack {
            Text(currentTime.minutesSeconds)
                .frame(width: 38, alignment: .trailing)
                .font(.caption)
                .foregroundStyle(.gray)
            
            Slider(value: Binding(get: {
                currentTime
            }, set: { newValue in
                // TODO: update player
                print("New value: \(newValue.minutesSeconds)")
                currentTime = newValue
               
            }), in: 0...totalTime)
            
            .foregroundStyle(.blue)
            
            Text(totalTime.minutesSeconds)
                .frame(width: 38, alignment: .leading)
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    PlaybackBar(totalTime: 275)
}
