//
//  PlaybackSpeed.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

import Foundation


enum PlaybackSpeed: Double {
    case slow = 0.5
    case normal = 1.0
    case faster = 1.5
    case fastest = 2.0
}

extension PlaybackSpeed {
    mutating func next() {
        let nextValue: Self
        switch self {
        case .slow:
            nextValue = .normal
        case .normal:
            nextValue = .faster
        case .faster:
            nextValue = .fastest
        case .fastest:
            nextValue = .slow
        }
        self = nextValue
    }
}
