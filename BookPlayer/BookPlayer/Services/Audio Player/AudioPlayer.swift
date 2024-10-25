//
//  AudioPlayer.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

import Foundation

enum AudioPlayerError: Error, Equatable {
    case sourceFileMissing
    case playerSetupFailed
    case decodeError
}

enum AudioPlayerEvent: Equatable {
    case didFinishPlaying(successfully: Bool)
    case didFailed(AudioPlayerError)
    case durationUpdated(TimeInterval)
}

protocol AudioPlayer: AnyObject {
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    var isPlaing: Bool { get }
    
    func prepareToPlay(_ filename: String) async -> AsyncStream<AudioPlayerEvent>
    func play() 
    func play(at time: TimeInterval)
    func pause()
    func forward(_ seconds: TimeInterval)
    func backward(_ seconds: TimeInterval)
    func updatePlaybackRate(_ rate: Float)
    func invalidate()
}
