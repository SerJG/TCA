//
//  BooksDataProviderLocalImp.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

// This is the implementation version of the BooksDataProvider, which fetches books from a JSON file.
class BooksDataProviderLocalImp: BooksDataProvider {
    
    private let sourceFile: String
    
    init(sourceFile: String) {
        self.sourceFile = sourceFile
    }
    
    func loadBooksData() async throws -> Data {
        guard let file = Bundle.main.url(forResource: sourceFile, withExtension: nil) else {
            throw BooksLoadError.loadFailed
        }
        
        let task = Task { () -> Data in
            do {
                return try Data(contentsOf: file)
            } catch {
                throw BooksLoadError.loadFailed
            }
        }
        
        return try await task.value
    }
}
