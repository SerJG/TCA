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
        contentView.onAppear {
            store.send(.displayPlayer)
        }
        .navigationTitle(store.book.title)
    }
    
    @ViewBuilder
    private var contentView: some View {
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
            Image(store.book.cover)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.vertical)
            
            Spacer()
            switch store.screenState {
            case .initial:
                ProgressView()
            case .displayingChapter:
                ChapterView(store: store.scope(state: \.chapterState, action: \.chapter))
                    .frame(maxHeight: 250)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            case .error:
                Text("There is no chapter available for this book.")
            }
            Spacer()
        }
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
              chapters: [.init(audio: "the-sonnets-001.mp3", title: "Sonet 1", text: "text"),
                         .init(audio: "the-sonnets-002.mp3", title: "Sonet 2", text: "text2"),
                         .init(audio: "the-sonnets-003.mp3", title: "Sonet 3", text: "Text3")])
    }
}
