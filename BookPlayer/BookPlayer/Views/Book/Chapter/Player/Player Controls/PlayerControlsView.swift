//
//  PlayerControlView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerControlsView: View {
    
    let store: StoreOf<PlayerControlsReducer>
    
    var body: some View {
        HStack(alignment: .center) {
            PlayerButton(.previous) { store.send(.prevButtonTapped) }
            Spacer(minLength: 10)
            PlayerButton( .backward) { store.send(.backwardButtonTapped) }
            Spacer(minLength: 10)
            PlayerButton(store.isPlaying ? .pause : .play ) {
                store.send(store.isPlaying ? .pauseButtonTapped : .playButtonTapped)
            }
            Spacer(minLength: 10)
            PlayerButton(.forward) { store.send(.forwardButtonTapped) }
            Spacer(minLength: 10)
            PlayerButton(.next) { store.send(.nextButtonTapped) }
        }
    }
}

#Preview {
    PlayerControlsView(store: .init(initialState: PlayerControlsReducer.State(), reducer: {
        PlayerControlsReducer()
    }))
}
