//
//  TimeInterval+Ext.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import Foundation

extension TimeInterval {
    var minutesSeconds: String {
        let minute = min (Int(self) / 60, 99)
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}
