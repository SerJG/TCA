//
//  RootDependencies.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    var booksDatasource: BooksDatasource {
        get { self[BooksDatasourceKey.self] }
        set { self[BooksDatasourceKey.self] = newValue }
    }
}

@DependencyClient
private struct BooksDatasourceKey: DependencyKey {
    static let liveValue: BooksDatasource = BooksDatasourceImp(
        dataProvider: BooksDataProviderLocalImp(
            sourceFile: EnvironmentConstant.booksFilename
        )
    )
}

