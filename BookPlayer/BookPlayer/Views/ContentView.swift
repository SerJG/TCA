//
//  ContentView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 23.10.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                let books = try? await  BooksDatasourceImp(
                    dataProvider: BooksDataProviderLocalImp(
                        sourceFile: "books.json"
                    )
                ).getBooks()
                if let books = books {
                    print(books)
                } else {
                    print("failed")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
