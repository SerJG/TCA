//
//  AudioPlayerImp.swift
//  BookPlayer
//
//  Created by Sergii Gordiienko on 25.10.2024.
//

import Foundation
import AVKit

class AudioPlayerImp: NSObject {
    private var player: AVAudioPlayer?
    private var continuation: AsyncStream<AudioPlayerEvent>.Continuation?
}

extension AudioPlayerImp: AudioPlayer {
    
    
    var currentTime: TimeInterval {
        player?.currentTime ?? 0
    }
    
    var duration: TimeInterval {
        player?.duration ?? 0
    }
    
    var isPlaing: Bool {
        player?.isPlaying ?? false
    }
    
    
    func prepareToPlay(_ filename: String) async -> AsyncStream<AudioPlayerEvent> {
        invalidate()
        
        return AsyncStream { [weak self] continuation in
            guard let self else {
                continuation.finish()
                return
            }
            guard let url = Bundle.main.url(forResource: filename, withExtension:nil) else {
                continuation.yield(.didFailed(.sourceFileMissing))
                continuation.finish()
                return
            }
            
            do {
                self.continuation = continuation
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player?.delegate = self
                self.player?.prepareToPlay()
                self.player?.enableRate = true
                
                if let duration = self.player?.duration {
                    continuation.yield(.durationUpdated(duration))
                }
                
            } catch {
                continuation.yield(.didFailed(.playerSetupFailed))
                continuation.finish()
            }
        }
    }
    
    func play()  {
        guard let player = player else { return }
        if !player.isPlaying {
            player.play()
        }
    }
    
    func pause()  {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        }
    }
    
    func forward(_ seconds: TimeInterval)  {
        guard let player = player else { return }
        player.currentTime = min(player.currentTime + seconds, player.duration)
    }
    
    func backward(_ seconds: TimeInterval)  {
        guard let player = player else { return }
        player.currentTime = max(player.currentTime - seconds, 0)
    }
    
    func play(at time: TimeInterval)  {
        guard let player = player else { return }
        if time > 0 && time < player.duration {
            player.currentTime = time
        }
    }
    
    func updatePlaybackRate(_ rate: Float)  {
        guard let player = player else { return }
        player.rate = rate
    }
    
    func invalidate() {
        player?.stop()
        self.player = nil
        continuation?.finish()
        continuation = nil
    }
}

extension AudioPlayerImp: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        continuation?.yield(.didFinishPlaying(successfully: flag))
        continuation?.finish()
        continuation = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
        continuation?.yield(.didFailed(.decodeError))
        continuation?.finish()
        continuation = nil
    }
}
