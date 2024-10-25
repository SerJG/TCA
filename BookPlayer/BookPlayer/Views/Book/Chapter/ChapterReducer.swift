//
//  ChapterReducer.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChapterReducer {
    @ObservableState
    
    struct State: Equatable {
        
        enum ScreenState: Equatable {
            case initial
            case error
            case playing
            case paused
        }
        
        var screenState: ScreenState = .initial
        var chapter: Book.Chapter
        var playbackSpeed: PlaybackSpeed = .normal
        var chapterNumber: Int
        var totalChaptersCount: Int
        
        
        var playerControls = PlayerControlsReducer.State()
    }
    
    enum Action {
        case initializePlayer
        case changeSpeed
        case playerControls(PlayerControlsReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.playerControls, action: \.playerControls) {
            PlayerControlsReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .playerControls(let playerControlsAtion):
                return handlePlayerControls(playerControlsAtion)
            case .initializePlayer:
                return .none
            case .changeSpeed:
                state.playbackSpeed.next()
                return .none
            }
        }
    }
}

extension ChapterReducer {
    private func handlePlayerControls(_ action: PlayerControlsReducer.Action) -> Effect<ChapterReducer.Action> {
        switch action {
        case .playButtonTapped:
            // TODO: play
            return .none
        case .pauseButtonTapped:
            // TODO: pause
            return .none
        case .forwardButtonTapped:
            // TODO: forward
            return .none
        case .backwardButtonTapped:
            // TODO: backward
            return .none
        case .nextButtonTapped, .prevButtonTapped:
            // Should be handled by parent - BookReducer
            return .none
        }
    }
}
