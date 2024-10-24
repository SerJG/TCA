//
//  Library.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LibraryReducer {
    @ObservableState
    struct State: Equatable {
        enum ScreenState: Equatable {
            case initial
            case loading
            case finishedLoading([Book])
            case error(BooksLoadError)
        }
        var screenState: ScreenState = .initial
        
        var books: [Row] {
            if case .finishedLoading(let books) = self.screenState {
                return books.map { Row(book: $0, id: .init()) }
            }
            return []
            
        }
        
        struct Row: Equatable, Identifiable {
            var book: Book
            let id: UUID
        }
    }
    
    
    enum Action: Equatable {
        case loadBooks
        case processBooks([Book])
        case processError(BooksLoadError)
    }
    
    @Dependency(\.booksDatasource) var booksDatasource
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadBooks:
                state.screenState = .loading
                return .run { send in
                    do {
                        let books = try await booksDatasource.getBooks()
                        await send(.processBooks(books))
                    } catch let error as BooksLoadError {
                        await send(.processError(error))
                    } catch {
                        await send(.processError(.unknown))
                    }
                }
            case .processBooks(let books):
                state.screenState = .finishedLoading(books)
                return .none
            case .processError(let error):
                state.screenState = .error(error)
                return .none
            }
        }
    }
}

