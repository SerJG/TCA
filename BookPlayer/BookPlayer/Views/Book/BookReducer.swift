//
//  BookReducer.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BookReducer {
    @ObservableState
    struct State: Equatable {
        
        enum ScreenState: Equatable {
            case initial
            case displaying(Book.Chapter)
            case error
        }
        
        var screenState: ScreenState = .initial
        var book: Book
        
        var currentChapter: Book.Chapter? {
            switch self.screenState {
            case .displaying(let chapter):
                return chapter
            default:
                return nil
            }
        }
    }
    
    enum Action {
        case displayPlayer
        case nextChapter
        case prevChapter
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // TODO: proper actions
            
            switch action {
            case .displayPlayer:
                guard !state.book.chapters.isEmpty,
                      let chapter = state.book.chapters.first else {
                    state.screenState = .error
                    return .none
                }
                state.screenState = .displaying(chapter)
                return .none
            case .nextChapter:
                // TODO: proper actions
                return .none
            case .prevChapter:
                // TODO: proper actions
                return .none
            }
            // TODO: implement
        }
    }
}
