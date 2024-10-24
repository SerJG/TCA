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
        var book: Book.Chapter
        var chapterNumber: Int
        var totalChaptersCount: Int
        
        enum Action {
            case initializePlayer
            case changeSpeed
            case play
            case pause
            case nextChapter
            case prevChapter
            case forward
            case backward
        }
        
    }
}
