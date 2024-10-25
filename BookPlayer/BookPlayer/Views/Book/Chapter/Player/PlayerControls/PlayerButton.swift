//
//  PlayerButton.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

struct PlayerButton: View {
    
    enum Kind {
        case next
        case previous
        case play
        case pause
        case forward
        case backward
    }

    let kind: Kind
    typealias Action = () -> Void
    private let action: Action?
    
    init(_ kind: Kind, action: Action? = nil) {
        self.kind = kind
        self.action = action
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            
            Label(kind.labelText, systemImage: kind.systemName)
                .labelStyle(.iconOnly)
                .imageScale(kind.scale)
        }
        .frame(width:  44, height: 44)
        .foregroundStyle(.black)
    }
}

extension PlayerButton.Kind {
    var systemName: String {
        switch self {
        case .next:
            "forward.end.fill"
        case .previous:
            "backward.end.fill"
        case .play:
            "play.fill"
        case .pause:
            "pause.fill"
        case .forward:
            "goforward.10"
        case .backward:
            "gobackward.5"
        }
    }
    
    var labelText: String {
        switch self {
        case .next:
            "Next chapter"
        case .previous:
            "Previous chapter"
        case .play:
            "Play"
        case .pause:
            "Pause"
        case .forward:
            "Go forward"
        case .backward:
            "Go backward"
        }
    }
    
    var scale: Image.Scale {
        switch self {
        case .next, .previous:
                .medium
        case .play, .pause:
                .large
        case  .backward, .forward:
                .medium
        }
    }
}

#Preview {
    Group {
        PlayerButton(.previous) {}
        PlayerButton(.backward) {}
        PlayerButton(.play) {}
        PlayerButton(.pause) {}
        PlayerButton(.forward) {}
        PlayerButton(.next) {}
    }
}
