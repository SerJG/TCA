//
//  Book.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

struct Book: Decodable, Equatable {
    let cover: String
    let author: String
    let title: String
    let chapters: [Chapter]
    
    struct Chapter: Decodable, Equatable  {
        let audio: String
        let title: String
        let text: String
    }
}
