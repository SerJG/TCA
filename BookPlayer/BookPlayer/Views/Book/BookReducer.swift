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
            case displayingChapter
            case error
        }
        
        var screenState: ScreenState = .initial
        var book: Book
        var chapterState: ChapterReducer.State!
        
        var currentChapterIndex: Int = 0 {
            didSet {
                updateChapterState()
            }
        }
    }
    
    enum Action {
        case displayPlayer
        case chapter(ChapterReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.chapterState, action: \.chapter) {
            ChapterReducer()
        }
        
        Reduce { state, action in
            switch action {
                
            case .displayPlayer:
                return displayPlayer(&state)
                
            case .chapter(let action):
                return handleChapter(&state, action: action)
            }
        }
    }
}

// MARK: - Action handlers
extension BookReducer {
    
    private func handleChapter(_ state: inout State, action: ChapterReducer.Action) -> Effect<BookReducer.Action> {
        switch action {
            
        case .playerControls(let action):
            return handlePlayerControl(&state, action: action)
            
        default:
            return .none
        }
    }
    
    private func handlePlayerControl(_ state: inout State, action: PlayerControlsReducer.Action) -> Effect<BookReducer.Action> {
        switch action {
            
        case .nextButtonTapped:
            state.nextChapter()
            return .none
            
        case .prevButtonTapped:
            state.prevChapter()
            return .none
            
        default:
            return .none
        }
    }
}

// MARK: - Effects helpers
extension BookReducer  {
    
    private func displayPlayer(_ state: inout State) -> Effect<BookReducer.Action> {
        guard !state.book.chapters.isEmpty else {
            state.screenState = .error
            return .none
        }
        
        state.currentChapterIndex = 0
        state.screenState = .displayingChapter
        return .none
    }
}


extension BookReducer.State {
    
    fileprivate mutating func updateChapterState() {
        guard currentChapterIndex < book.chapters.count,
              currentChapterIndex >= 0  else { return }
        
        chapterState = .init(chapter: book.chapters[currentChapterIndex],
                             chapterNumber:  currentChapterIndex+1,
                             totalChaptersCount: book.chapters.count)
    }
    
    fileprivate mutating func nextChapter() {
        guard currentChapterIndex < book.chapters.count-1 else { return }
        currentChapterIndex += 1
    }
    
    fileprivate mutating func prevChapter() {
        guard currentChapterIndex > 0 else { return }
        currentChapterIndex -= 1
    }
}
