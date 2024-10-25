//
//  PlaybackSliderReducer.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlaybackSliderReducer {
    @ObservableState
    struct State: Equatable {
        var currentTime: TimeInterval = 0
        var durationTime: TimeInterval = 0
    }
    
    enum Action {
        case setTime(TimeInterval)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setTime(_):
                return .none
            }
        }
    }
}
