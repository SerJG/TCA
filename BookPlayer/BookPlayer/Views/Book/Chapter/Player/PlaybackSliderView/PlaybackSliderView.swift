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
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Text(viewStore.state.currentTime.minutesSeconds)
                    .frame(width: 38, alignment: .trailing)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Slider(value: Binding(get: {
                    viewStore.state.currentTime
                }, set: { newValue in
                    viewStore.send(.setTime(newValue))
                }), in: 0...viewStore.state.durationTime)
                
                .foregroundStyle(.blue)
                
                Text(viewStore.state.durationTime.minutesSeconds)
                    .frame(width: 38, alignment: .leading)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    PlaybackSliderView(store: .init(initialState: PlaybackSliderReducer.State(), reducer: {
        PlaybackSliderReducer()
    }))
}
