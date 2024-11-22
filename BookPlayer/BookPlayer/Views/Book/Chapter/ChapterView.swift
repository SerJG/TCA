//
//  ChapterView.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 24.10.2024.
//

import SwiftUI
import ComposableArchitecture

struct ChapterView: View {
    
    @Bindable var store: StoreOf<ChapterReducer>
    
    var body: some View {
        contentView
            .onDisappear {
                store.send(.resetPlayer)
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch store.state.screenState {
        case .initial:
            VStack {
                Spacer()
                ProgressView()
                    .onAppear {
                        store.send(.initializePlayer)
                    }
                Spacer()
            }
        case .error:
            Text("Oops.. unfortunately, we can't play this chapter for you. 💔")
        case .ready:
            VStack {
                Text("Chapter \(store.chapterNumber) of \(store.totalChaptersCount)".uppercased())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                Text(store.chapter.title)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(2)
                
                PlaybackSliderView(store: store.scope(state: \.playbackSlider, action: \.playbackSlider))
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                PlaybackRateButton(store.playbackRate) {
                    store.send(.changeRate)
                }
                .padding(.vertical)
                
                PlayerControlsView(store: store.scope(state: \.playerControls, action: \.playerControls))
                    .padding(.top, 16)
                    .padding(.horizontal, 60)
                
                Button {
                    store.send(.shouldShowText(true))
                } label: {
                    Label("Show text", systemImage: "text.page.fill")
                        .padding()
                        .foregroundStyle(.gray)
                }
            }
            .sheet(isPresented: $store.shouldShowText.sending(\.shouldShowText)) {
                ScrollView {
                    Text(store.chapter.text)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ChapterView(store: .init(initialState: ChapterReducer.State.init(screenState: .ready, chapter: .init(audio: "test.mp3", title: "Some long title for the chapter in the book. Some long title for ", text: "Test"), chapterNumber: 1, totalChaptersCount: 10), reducer: {
        ChapterReducer()
    }))
}
