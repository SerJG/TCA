//
//  BooksProdiver.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

enum BooksLoadError: Error {
    case loadFailed, decodeFailed
}

protocol BooksDatasource {
    var dataProvider: BooksDataProvider { get }
    
    func getBooks() async throws -> [Book]
}

protocol BooksDataProvider {
    func loadBooksData() async throws -> Data
}
