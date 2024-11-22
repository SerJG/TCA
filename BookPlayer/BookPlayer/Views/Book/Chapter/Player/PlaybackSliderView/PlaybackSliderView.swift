//
//  PlaybackSliderView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlaybackSliderView: View {
    
    let store: StoreOf<PlaybackSliderReducer>
    
    var body: some View {
        HStack {
            Text(store.state.currentTime.minutesSeconds)
                .frame(width: 38, alignment: .trailing)
                .font(.caption)
                .foregroundStyle(.gray)
            
            Slider(value: Binding(get: {
                store.state.currentTime
            }, set: { newValue in
                store.send(.setTime(newValue))
            }), in: 0...store.state.durationTime)
            .foregroundStyle(.blue)
            
            Text(store.state.durationTime.minutesSeconds)
                .frame(width: 38, alignment: .leading)
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    PlaybackSliderView(store: .init(initialState: PlaybackSliderReducer.State(), reducer: {
        PlaybackSliderReducer()
    }))
}
