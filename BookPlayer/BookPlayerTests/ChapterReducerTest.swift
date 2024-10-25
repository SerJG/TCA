//
//  ChapterReducerTest.swift
//  BookPlayerTests
//
//  Created by Sergii Gordiienko on 25.10.2024.
//
import XCTest
import ComposableArchitecture
import Testing

@testable import BookPlayer


@MainActor
final class ChapterReducerTest: XCTestCase {
    
    func testChapterReducerHappyPath() async {
        let mockPlayer = PlayerMockImp()
        let clock = TestClock()
        let store = TestStore(
            initialState:  ChapterReducer.State.init(
                screenState: .initial,
                chapter: .init(
                    audio: "test.mp3",
                    title: "Some long title for the chapter in the book. Some long title for ",
                    text: "Test"
                ),
                chapterNumber: 1,
                totalChaptersCount: 10
            )
        ) {
            ChapterReducer()
        } withDependencies: {
            $0.audioPlayer = mockPlayer
            $0.continuousClock = clock
        }
        store.exhaustivity = .off
        
        // Initialize player
        await store.send(\.initializePlayer)
        assert(mockPlayer.isReady == false)
        assert(mockPlayer.isPlaing == false)
        
        // Reciave duration time update
        await store.receive(\.audioPlayerEvent, timeout: .seconds(1)) {
            $0.screenState = .ready
            $0.playbackSlider.currentTime = 0
            $0.playbackSlider.durationTime = mockPlayer.expectingDuration
            $0.playerControls.isPlaying = false
        }
        
        // Autoplayback is started
        assert(mockPlayer.isReady == true)
        var expectedPlaybackTime = mockPlayer.expectingDuration / 2
        await store.receive(\.updateCurrentTime) {
            $0.playbackSlider.currentTime = expectedPlaybackTime
            $0.playerControls.isPlaying = true
        }
        assert(mockPlayer.isPlaing == true)
        
        // Change playback rate
        await store.send(.changeRate) {
            $0.playbackRate = .faster
        }
        assert(mockPlayer.rate == PlaybackRate.faster.rawValue)
        
        // Pause playback
        await store.send(.playerControls(.pauseButtonTapped)) {
            $0.playerControls.isPlaying = false
        }
        assert(mockPlayer.isPlaing == false)
        
        // Continue playback
        await store.send(.playerControls(.playButtonTapped)) {
            $0.playerControls.isPlaying = true
        }
        assert(mockPlayer.isPlaing == true)
        
        // Forward for 10 second
        expectedPlaybackTime += 10
        await store.send(.playerControls(.forwardButtonTapped))
        await store.receive(\.updateCurrentTime) {
            $0.playbackSlider.currentTime = expectedPlaybackTime
        }
        
        // Backward for 5 second
        expectedPlaybackTime -= 5
        await store.send(.playerControls(.backwardButtonTapped))
        await store.receive(\.updateCurrentTime) {
            $0.playbackSlider.currentTime = expectedPlaybackTime
        }
        
        // Set playback at time
        expectedPlaybackTime = mockPlayer.expectingDuration / 2
        await store.send(.playbackSlider(.setTime(expectedPlaybackTime)))
        await store.receive(\.updateCurrentTime) {
            $0.playbackSlider.currentTime = expectedPlaybackTime
        }
        
        // Show text
        await store.send(.shouldShowText(true)) {
            $0.shouldShowText = true
        }
        
        // Hide text
        await store.send(.shouldShowText(false)) {
            $0.shouldShowText = false
        }
        
        // Reciave finish playback
        mockPlayer.finishPlaying(true)
        await store.receive(\.audioPlayerEvent) {
            $0.playerControls.isPlaying = false
        }
        
        // Invalidate player
        await store.send(.resetPlayer)
        assert(mockPlayer.isInvalidated == true)
    }
    
    func testChapterReducerError() async {
        let mockPlayer = PlayerMockImp()
        let clock = TestClock()
        let store = TestStore(
            initialState:  ChapterReducer.State.init(
                screenState: .initial,
                chapter: .init(
                    audio: "test.mp3",
                    title: "Some long title for the chapter in the book. Some long title for ",
                    text: "Test"
                ),
                chapterNumber: 1,
                totalChaptersCount: 10
            )
        ) {
            ChapterReducer()
        } withDependencies: {
            $0.audioPlayer = mockPlayer
            $0.continuousClock = clock
        }
        store.exhaustivity = .off
        
        // Initialize player
        await store.send(\.initializePlayer)
        assert(mockPlayer.isReady == false)
        assert(mockPlayer.isPlaing == false)
        
        // Reciave duration time update
        await store.receive(\.audioPlayerEvent, timeout: .seconds(1)) {
            $0.screenState = .ready
            $0.playbackSlider.currentTime = 0
            $0.playbackSlider.durationTime = mockPlayer.expectingDuration
            $0.playerControls.isPlaying = false
        }
        
        // Reciave finish playback
        mockPlayer.sendError(.decodeError)
        await store.receive(\.audioPlayerEvent, timeout: .seconds(1)) {
            $0.screenState = .error
        }
    }
}
