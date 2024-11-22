//
//  BooksDatasourceImp.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

actor BooksDatasourceImp: BooksDatasource {
    
    var books: [Book] = []
    let dataProvider: BooksDataProvider
    
    private var loadTask: Task<[Book], any Error>?
    
    init(dataProvider: BooksDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func getBooks() async throws -> [Book] {
        if let loadTask {
            return try await loadTask.value
        }
        
        let loadTask = Task { [weak self] in
            guard let self else { throw BooksLoadError.unknown }
            let data = try await dataProvider.loadBooksData()
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([Book].self, from: data)
            } catch {
                throw BooksLoadError.decodeFailed
            }
        }
        
        self.loadTask = loadTask
        books = try await loadTask.value
        self.loadTask = nil
        
        return books
    }
}
