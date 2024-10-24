//
//  BookView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

struct BookView: View {
    let book: Book
    
    var body: some View {
        VStack {
            Spacer()
            Text(book.title)
                .font(.title)
            Text("by \(book.author)")
                .font(.title3)
                .italic()
            Image(.theSonnetsCover)
                .resizable()
                .scaledToFit()
                .padding(.vertical)
            Text("Chapter 1 of 10".uppercased())
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)


            ChapterView(chapter: book.chapters.first!)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            Spacer()
        }
    }
}

#Preview {
    BookView(book: .init(cover: "the-sonnets-cover",
                         author: "William Shakespeare",
                         title: "The Sonnets",
                         chapters: [.init(audio: "", title: "Sonet 1", text: "text")]))
}
