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
        var playbackRate: PlaybackRate = .normal
        var chapterNumber: Int
        var totalChaptersCount: Int
        
        
        var playerControls = PlayerControlsReducer.State()
    }
    
    enum Action {
        case initializePlayer
        case changeRate
        case audioPlayerEvent(AudioPlayerEvent)
        case updateCurrentTime(TimeInterval)
        case playerControls(PlayerControlsReducer.Action)
    }
    
    @Dependency(\.audioPlayer) var audioPlayer
    
    var body: some ReducerOf<Self> {
        Scope(state: \.playerControls, action: \.playerControls) {
            PlayerControlsReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .playerControls(let playerControlsAtion):
                return handlePlayerControls(&state, playerControlsAtion)
            case .initializePlayer:
                let chapterAudioFile = state.chapter.audio
                return .run { send in
                    let stream = await audioPlayer.prepareToPlay(chapterAudioFile)
                                for await event in stream {
                                    await send(.audioPlayerEvent(event))
                                }
                            }
                            .cancellable(id: "AudioPlayer", cancelInFlight: true)
                            .merge(with:
                                // Start a timer to update currentTime
                                .run { [audioPlayer] send in
                                    while true {
                                        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                                        await send(.updateCurrentTime(audioPlayer.currentTime))
                                    }
                                }
                                .cancellable(id: "Timer")
                            )
            case .changeRate:
                state.playbackRate.next()
                audioPlayer.updatePlaybackRate(state.playbackRate.rawValue)
                return .none
            case .audioPlayerEvent(let event):
                switch event {case .didFinishPlaying(successfully: let successfully):
                    // TODO: show message
                    return .none
                case .didFailed(_):
                    state.screenState = .error
                    return .none
                case .durationUpdated(let time):
                    // TODO: update duration time
                    return .none
                }
            case .updateCurrentTime(_):
                // TODO: update time
                return .none
            }
        }
    }
}

extension ChapterReducer {
    private func handlePlayerControls(_ state: inout State, _ action: PlayerControlsReducer.Action) -> Effect<ChapterReducer.Action> {
        switch action {
        case .playButtonTapped:
            audioPlayer.play()
            state.playerControls.isPlaying = audioPlayer.isPlaing
            return .none
        case .pauseButtonTapped:
            audioPlayer.pause()
            state.playerControls.isPlaying = audioPlayer.isPlaing
            return .none
        case .forwardButtonTapped:
            audioPlayer.forward(10)
            return .none
        case .backwardButtonTapped:
            audioPlayer.backward(10)
            return .none
        case .nextButtonTapped, .prevButtonTapped:
            // Should be handled by parent - BookReducer
            return .none
        }
    }
}
