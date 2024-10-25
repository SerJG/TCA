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
                guard !state.book.chapters.isEmpty else {
                    state.screenState = .error
                    return .none
                }
                state.currentChapterIndex = 0
                state.screenState = .displayingChapter
                return .none
                
            case .chapter(let action):
                switch action {
                case .playerControls(let action):
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
                default:
                    return .none
                }
            }
        }
    }
}
