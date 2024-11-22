//
//  ContentView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 23.10.2024.
//

import SwiftUI
import ComposableArchitecture

struct LibraryView: View {
    
    let store: StoreOf<LibraryReducer>
    
    var body: some View {
        contentView
        .onAppear {
            if case .initial = store.screenState {
                store.send(.loadBooks)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch store.state.screenState {
        case .initial, .loading:
            ProgressView("Loading books")
            
        case .finishedLoading(_):
            NavigationStack {
                Form {
                    ForEach(store.books) { row in
                        NavigationLink("\(row.book.title) by \(row.book.author)") {
                            BookView(
                                store: Store(
                                    initialState: BookReducer.State(
                                        book: row.book
                                    ),
                                    reducer: {
                                        BookReducer()
                                    })
                            )
                        }
                    }
                }
                .navigationTitle("Your library")
            }
            
        case .error(_):
            VStack {
                Text("There are some problems with loading your books library. 🥺")
                    .padding()
                    .multilineTextAlignment(.center)
                Button("Retry... 🙏") {
                    store.send(.loadBooks)
                }
            }
        }
    }
}

#Preview {
    LibraryView(
        store: Store(
            initialState: LibraryReducer.State()
        ) { LibraryReducer() })
}
