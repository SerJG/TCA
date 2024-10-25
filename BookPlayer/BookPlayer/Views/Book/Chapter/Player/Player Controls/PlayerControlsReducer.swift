//
//  PlayerControlsReducer.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerControlsReducer {
    @ObservableState
    struct State: Equatable {
        var isPlaying: Bool = false
    }
    
    enum Action {
        case playButtonTapped
        case pauseButtonTapped
        case nextButtonTapped
        case prevButtonTapped
        case forwardButtonTapped
        case backwardButtonTapped
  }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backwardButtonTapped:
                return .none
            case .forwardButtonTapped:
                return .none
            case .pauseButtonTapped:
                return .none
            case .playButtonTapped:
                return .none
            case .nextButtonTapped, .prevButtonTapped:
                return .none
            }
        }
    }
}
