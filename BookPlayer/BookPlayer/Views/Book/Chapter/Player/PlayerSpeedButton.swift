//
//  SwiftUIView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

enum PlaybackSpeed: Float {
    case slow = 0.5
    case normal = 1.0
    case faster = 1.5
    case fastest = 2.0
}

extension PlaybackSpeed {
    mutating func next() {
        let nextValue: Self
        switch self {
        case .slow:
            nextValue = .normal
        case .normal:
            nextValue = .faster
        case .faster:
            nextValue = .fastest
        case .fastest:
            nextValue = .slow
        }
        self = nextValue
    }
    
    var displayValue: String {
        switch self {
        case .slow:
            "x0.5"
        case .normal:
            "x1"
        case .faster:
            "x1.5"
        case .fastest:
            "2"
        }
    }
}

struct PlayerSpeedButton: View {
    @State private var speed: PlaybackSpeed = .normal
    
    var body: some View {
        
        Text("Speed \(speed.displayValue)")
            .padding(8)
            .font(.subheadline)
            .foregroundStyle(.black)
            .background(Color(red: 0.8, green: 0.8, blue: 0.8))
            .opacity(0.8)
            .clipShape(.buttonBorder)
            .onTapGesture {
                // TODO: speed update action
                speed.next()
            }

    }
}

#Preview {
    PlayerSpeedButton()
}
