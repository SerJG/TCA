//
//  ChapterView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI
import ComposableArchitecture

struct ChapterView: View {
    
    let store: StoreOf<ChapterReducer>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Chapter \(viewStore.chapterNumber) of \(viewStore.totalChaptersCount)".uppercased())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                Text(viewStore.chapter.title)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(2)
                
                PlaybackBar(totalTime: 300)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                PlaybackRateButton(viewStore.playbackRate) {
                    viewStore.send(.changeRate)
                }
                    .padding(.vertical)
                
                PlayerControlsView(store: store.scope(state: \.playerControls, action: \.playerControls))
                .padding(.top, 16)
                .padding(.horizontal, 60)
            }
        }.onAppear {
            store.send(.initializePlayer)
        }
        
    }
}

#Preview {
    ChapterView(store: .init(initialState: ChapterReducer.State.init(chapter: .init(audio: "test.mp3", title: "Some long title for the chapter in the book. Some long title for ", text: "Test"), chapterNumber: 1, totalChaptersCount: 10), reducer: {
        ChapterReducer()
    }))
}
