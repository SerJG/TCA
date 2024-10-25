//
//  SwiftUIView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

struct PlaybackSpeedButton: View {
    private var speed: PlaybackSpeed = .normal
    typealias Action = () -> Void
    private let action: Action?
    
    init(_ speed: PlaybackSpeed, action: Action? = nil) {
        self.speed = speed
        self.action = action
    }
    
    var body: some View {
        
        Text("Speed \(speed.displayValue)")
            .padding(8)
            .font(.subheadline)
            .foregroundStyle(.black)
            .background(Color(red: 0.8, green: 0.8, blue: 0.8))
            .opacity(0.8)
            .clipShape(.buttonBorder)
            .onTapGesture {
                action?()
            }

    }
}

extension PlaybackSpeed {
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

#Preview {
    PlaybackSpeedButton(.normal)
}
