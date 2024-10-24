//
//  PlayerControlView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

struct PlayerControlView: View {
    var body: some View {
        HStack(alignment: .center) {
            PlayerButton(kind: .previous)
            Spacer(minLength: 10)
            PlayerButton(kind: .backward)
            Spacer(minLength: 10)
            PlayerButton(kind: .play)
            Spacer(minLength: 10)
            PlayerButton(kind: .forward)
            Spacer(minLength: 10)
            PlayerButton(kind: .next)
        }
    }
}

#Preview {
    PlayerControlView()
}
