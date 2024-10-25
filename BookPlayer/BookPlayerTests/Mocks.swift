//
//  Mocks.swift
//  BookPlayerTests
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

@testable import BookPlayer
import Foundation

enum SleepIntervals  {
    static let halfSecond: UInt64 = 500_000_000
    static let second: UInt64 = halfSecond * 2
    static let twoSecond: UInt64 = second * 2
}

class PlayerMockImp: AudioPlayer {
    
    private var continuation: AsyncStream<AudioPlayerEvent>.Continuation?
    
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    let expectingDuration: TimeInterval = 100
    var rate: Float = 1.0
    var isPlaing: Bool = false
    var isReady: Bool = false
    var isInvalidated: Bool = false
    
    deinit {
        continuation?.finish()
    }
    
    func prepareToPlay(_ filename: String) async -> AsyncStream<BookPlayer.AudioPlayerEvent> {
        return AsyncStream { [weak self] continuation in
            guard let self else {
                continuation.finish()
                return
            }
            self.continuation = continuation
            
            Task {
                try? await Task.sleep(nanoseconds: SleepIntervals.halfSecond)
                
                self.isReady = true
                self.duration = self.expectingDuration
                
                continuation.yield(.durationUpdated(self.duration))
            }
        }
    }
    
    func play() {
        currentTime = expectingDuration/2
        isPlaing = true
    }
    
    func play(at time: TimeInterval) {
        currentTime = time
        isPlaing = true
    }
    
    func pause() {
        isPlaing = false
    }
    
    func forward(_ seconds: TimeInterval) {
        currentTime += seconds
    }
    
    func backward(_ seconds: TimeInterval) {
        currentTime -= seconds
    }
    
    func updatePlaybackRate(_ rate: Float) {
        self.rate = rate
    }
    
    func invalidate() {
        isPlaing = false
        isInvalidated = true
        currentTime = 0
    }
}

extension PlayerMockImp {
    func sendError(_ error: AudioPlayerError) {
        isPlaing = false
        continuation?.yield(.didFailed(error))
    }
    
    func finishPlaying(_ success: Bool) {
        isPlaing = false
        continuation?.yield(.didFinishPlaying(successfully: success))
    }
}
