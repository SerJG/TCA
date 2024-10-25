//
//  BookReducer.swift
//  BookReducer
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

import XCTest
import ComposableArchitecture
import Testing

@testable import BookPlayer

@MainActor
final class BookPlayerTests: XCTestCase {
    
    func testBookReducerHappyPath() async {
        let mockPlayer = PlayerMockImp()
        let clock = TestClock()
        let store = TestStore(
            initialState:  BookReducer.State.init(book: .testBook)
        ) {
            BookReducer()
        } withDependencies: {
            $0.audioPlayer = mockPlayer
            $0.continuousClock = clock
        }
        store.exhaustivity = .off
        
        assert(store.state.screenState == .initial)
        await store.send(.displayPlayer) {
            $0.screenState = .displayingChapter
            $0.currentChapterIndex = 0
        }
        
        // Try to select previous  at start
        await store.send(.chapter(.playerControls(.prevButtonTapped))) {
            $0.currentChapterIndex = 0
        }
        
        // Select next
        await store.send(.chapter(.playerControls(.nextButtonTapped))) {
            $0.currentChapterIndex = 1
        }
        
        // Select next
        await store.send(.chapter(.playerControls(.nextButtonTapped))) {
            $0.currentChapterIndex = 2
        }
        
        // Select next
        await store.send(.chapter(.playerControls(.nextButtonTapped))) {
            $0.currentChapterIndex = 3
        }
        
        // Select next last one
        await store.send(.chapter(.playerControls(.nextButtonTapped))) {
            $0.currentChapterIndex = 4
        }
        
        // Try select next at end
        await store.send(.chapter(.playerControls(.nextButtonTapped))) {
            $0.currentChapterIndex = 4
        }
        
        // Select previous
        await store.send(.chapter(.playerControls(.prevButtonTapped))) {
            $0.currentChapterIndex = 3
        }
    }
    
    
    func testBookReducerError() async {
        let mockPlayer = PlayerMockImp()
        let clock = TestClock()
        let store = TestStore(
            initialState:  BookReducer.State.init(book: .testEmptyBook)
        ) {
            BookReducer()
        } withDependencies: {
            $0.audioPlayer = mockPlayer
            $0.continuousClock = clock
        }
        store.exhaustivity = .off
        
        assert(store.state.screenState == .initial)
        await store.send(.displayPlayer) {
            $0.screenState = .error
            $0.currentChapterIndex = 0
        }
    }
}


extension Book {
    static let testBook: Self = .init(cover: "testbook.png", author: "Test Author", title: "Test book", chapters: Self.testChapters)
    static let testEmptyBook: Self = .init(cover: "testbook.png", author: "Test Author", title: "Test book", chapters: [])
    
    static let testChapters: [Book.Chapter] = [
        .init(
            audio: "test.mp3",
            title: "Test 1",
            text: "Test 1"
        ),
        .init(
            audio: "test.mp3",
            title: "Test 2",
            text: "Test 2"
        ),
        .init(
            audio: "test.mp3",
            title: "Test 3",
            text: "Test 3"
        ),
        .init(
            audio: "test.mp3",
            title: "Test 4",
            text: "Test 4"
        ),
        .init(
            audio: "test.mp3",
            title: "Test 5",
            text: "Test 5"
        )
    ]
}
