//
//  ChapterDependencies.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var audioPlayer: AudioPlayer {
        get { self[AudioPlayerKey.self] }
        set { self[AudioPlayerKey.self] = newValue }
    }
}

@DependencyClient
private struct AudioPlayerKey: DependencyKey {
    static let liveValue: AudioPlayer = AudioPlayerImp()
}
