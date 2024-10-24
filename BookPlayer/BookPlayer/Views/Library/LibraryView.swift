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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            switch viewStore.state.screenState {
            case .initial, .loading:
                ProgressView("Loading books")
                
            case .finishedLoading(let books):
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
                        viewStore.send(.loadBooks)
                    }
                }
            }
        }
        .onAppear {
            if case .initial = store.screenState {
                store.send(.loadBooks)
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
