//
//  BooksProdiver.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

enum BooksLoadError: Error, Equatable {
    case loadFailed, decodeFailed, unknown
}

// BooksDatasource contains a BooksDataProvider that serves as the raw data source and deserializes it into an array of Book objects.
protocol BooksDatasource {
    var dataProvider: BooksDataProvider { get }
    
    func getBooks() async throws -> [Book]
}

// BooksDataProvider that serves as the raw data source 
protocol BooksDataProvider: Sendable {
    func loadBooksData() async throws -> Data
}
