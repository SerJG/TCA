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
            case ready
        }
        
        var screenState: ScreenState = .initial
        var chapter: Book.Chapter
        var playbackRate: PlaybackRate = .normal
        var shouldShowText: Bool = false
        var chapterNumber: Int
        var totalChaptersCount: Int
        
        var playerControls = PlayerControlsReducer.State()
        var playbackSlider = PlaybackSliderReducer.State()
    }
    
    enum Action {
        case initializePlayer
        case resetPlayer
        case shouldShowText(Bool)
        case changeRate
        case audioPlayerEvent(AudioPlayerEvent)
        case updateCurrentTime(TimeInterval)
        case playerControls(PlayerControlsReducer.Action)
        case playbackSlider(PlaybackSliderReducer.Action)
    }
    
    @Dependency(\.audioPlayer) var audioPlayer
    
    var body: some ReducerOf<Self> {
        Scope(state: \.playerControls, action: \.playerControls) {
            PlayerControlsReducer()
        }
        Scope(state: \.playbackSlider, action: \.playbackSlider) {
            PlaybackSliderReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .playerControls(let playerControlsAtion):
                return handlePlayerControls(&state, playerControlsAtion)
                
            case .initializePlayer:
                state.screenState = .initial
                let chapterAudioFile = state.chapter.audio
                return invalidatePlayerAndTimers().merge(with: initilizePlayer(chapterAudioFile))
                
            case .changeRate:
                state.playbackRate.next()
                audioPlayer.updatePlaybackRate(state.playbackRate.rawValue)
                return .none
                
            case .audioPlayerEvent(let event):
                return hadnleAudioPlayerEvent(&state, event)
                
            case .updateCurrentTime(let time):
                state.playbackSlider.currentTime = time
                return .none
                
            case .playbackSlider(let action):
                return handlePlaybackSlider(action)
                
            case .resetPlayer:
                return invalidatePlayerAndTimers()
            case .shouldShowText(let value):
                state.shouldShowText = value
                return .none
            }
        }
    }
}

// MARK: - Actions handlers
extension ChapterReducer {
    private func startCurrentTimeTimer() -> Effect<ChapterReducer.Action> {
        return .run { [audioPlayer] send in
            while true {
                try await Task.sleep(nanoseconds: 500_000_000)
                await send(.updateCurrentTime(audioPlayer.currentTime))
            }
        }
        .cancellable(id: CancelID.currentTime)
    }
    
    private func handlePlayerControls(_ state: inout State, _ action: PlayerControlsReducer.Action) -> Effect<ChapterReducer.Action> {
        switch action {
            
        case .playButtonTapped:
            audioPlayer.play()
            state.playerControls.isPlaying = audioPlayer.isPlaing
            return startCurrentTimeTimer()
        case .pauseButtonTapped:
            audioPlayer.pause()
            state.playerControls.isPlaying = audioPlayer.isPlaing
            return .cancel(id: CancelID.currentTime)
        case .forwardButtonTapped:
            audioPlayer.forward(PlaybackJumpValue.forwardJumpValue)
            return .none
        case .backwardButtonTapped:
            audioPlayer.backward(PlaybackJumpValue.backwardJumpValue)
            return .none
        case .nextButtonTapped, .prevButtonTapped:
            return invalidateTimers()
        }
    }
    
    private func handlePlaybackSlider(_ action: PlaybackSliderReducer.Action) -> Effect<ChapterReducer.Action> {
        switch action {
        case .setTime(let time):
            audioPlayer.play(at: time)
            return .none
        }
    }
    
    private func hadnleAudioPlayerEvent(_ state: inout ChapterReducer.State, _ event: AudioPlayerEvent) -> Effect<ChapterReducer.Action> {
        switch event {
            
        case .didFinishPlaying(successfully: let successfully):
            state.playerControls.isPlaying = audioPlayer.isPlaing
            return successfully ? .send(.playerControls(.nextButtonTapped)) : invalidateTimers()
            
        case .didFailed(let error):
            print("\(#function) - \(error)")
            state.screenState = .error
            return invalidateTimers()
            
        case .durationUpdated(let time):
            state.screenState = .ready
            state.playbackSlider.durationTime = time
            return .send(.playerControls(.playButtonTapped))
        }
    }
}

// MARK: - Effects helpers
extension ChapterReducer {
    private func invalidatePlayer() -> Effect<ChapterReducer.Action> {
        audioPlayer.invalidate()
        return .none
    }
    
    private func invalidateTimers() -> Effect<ChapterReducer.Action> {
        .cancel(id: CancelID.currentTime)
        .merge(with: .cancel(id: CancelID.audioPlayer))
    }
    private func invalidatePlayerAndTimers() -> Effect<ChapterReducer.Action> {
        return invalidateTimers().merge(with: invalidatePlayer())
    }
    
    private func initilizePlayer(_ chapterAudioFile: String) -> Effect<ChapterReducer.Action> {
        .run { send in
            let stream = await audioPlayer.prepareToPlay(chapterAudioFile)
            for await event in stream {
                await send(.audioPlayerEvent(event))
            }
        }
        .cancellable(id: CancelID.audioPlayer, cancelInFlight: true)
        .merge(with: startCurrentTimeTimer())
    }
}

// MARK: - Constants
extension ChapterReducer {
    enum PlaybackJumpValue {
        static let forwardJumpValue: TimeInterval = 10
        static let backwardJumpValue: TimeInterval = 5
    }
    
    private enum CancelID {
        static let audioPlayer = "AudioPlayer"
        static let currentTime = "Timer"
        
    }
}
