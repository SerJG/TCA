//
//  ChapterView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI

struct ChapterView: View {
    let chapter: Book.Chapter
    
    var body: some View {
        VStack {
            Text(chapter.title)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .lineLimit(2)
            
            PlaybackBar(totalTime: 300)
                .padding(.top, 20)
                .padding(.horizontal)
            
            PlayerSpeedButton()
                .padding(.vertical)
            
            PlayerControlView()
                .padding(.top, 16)
                .padding(.horizontal, 60)
        }
        
    }
}

#Preview {
    ChapterView(with: .init(audio: "test.mp3", title: "Some long title for the chapter in the book. Some long title for ", text: "Test"))
}

extension ChapterView {
    init (with currentChapter: Book.Chapter) {
        self.chapter = currentChapter
    }
}
