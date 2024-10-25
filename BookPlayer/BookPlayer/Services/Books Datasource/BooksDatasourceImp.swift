//
//  BooksDatasourceImp.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

class BooksDatasourceImp: BooksDatasource {
    
    var books: [Book] = []
    let dataProvider: BooksDataProvider
    
    init(dataProvider: BooksDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func getBooks() async throws -> [Book] {
        guard books.isEmpty else { return books }
        
        let task = Task { [weak self] () -> [Book] in
            guard let self else { return [] }
            do {
                let data = try await dataProvider.loadBooksData()
                let decoder = JSONDecoder()
                self.books = try decoder.decode([Book].self, from: data)
                return self.books
            } catch let error as BooksLoadError {
                throw error
            } catch {
                throw BooksLoadError.decodeFailed
            }
        }
        return try await task.value
    }
}
