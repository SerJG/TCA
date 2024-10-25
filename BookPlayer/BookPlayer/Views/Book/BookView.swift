//
//  BookView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookView: View {
    
    let store: StoreOf<BookReducer>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("by \(store.book.author)")
                        .font(.title3)
                        .italic()
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    Spacer()
                }
                Spacer()
                Image(.theSonnetsCover)
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical)
                switch store.screenState {
                case .initial:
                    ProgressView()
                case .displayingChapter:
                    ChapterView(store: store.scope(state: \.chapterState, action: \.chapter))
                            .padding(.top, 8)
                            .padding(.bottom, 20)
                case .error:
                    Text("There is no chapter available for this book.")
                }
            Spacer()
            }

        }.onAppear {
            store.send(.displayPlayer)
        }
        .navigationTitle(store.book.title)
    }
}

#Preview {
    
    BookView(store: .init(initialState: BookReducer.State(book: Book.dummyBook), reducer: { BookReducer() }))

}

fileprivate extension Book {
    static var dummyBook: Book {
        .init(cover: "the-sonnets-cover",
              author: "William Shakespeare",
              title: "The Sonnets",
              chapters: [.init(audio: "", title: "Sonet 1", text: "text")])
    }
}
