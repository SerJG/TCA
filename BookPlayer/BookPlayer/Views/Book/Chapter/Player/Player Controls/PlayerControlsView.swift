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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            HStack(alignment: .center) {
                PlayerButton(.previous) { viewStore.send(.prevButtonTapped) }
                Spacer(minLength: 10)
                PlayerButton( .backward) { viewStore.send(.backwardButtonTapped) }
                Spacer(minLength: 10)
                PlayerButton(viewStore.isPlaying ? .pause : .play ) {
                    viewStore.send(viewStore.isPlaying ? .pauseButtonTapped : .playButtonTapped)
                }
                Spacer(minLength: 10)
                PlayerButton(.forward) { viewStore.send(.forwardButtonTapped) }
                Spacer(minLength: 10)
                PlayerButton(.next) { viewStore.send(.nextButtonTapped) }
            }
        }
    }
}

#Preview {
    PlayerControlsView(store: .init(initialState: PlayerControlsReducer.State(), reducer: {
        PlayerControlsReducer()
    }))
}
