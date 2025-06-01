import AVKit
import SwiftUI

struct PlayerView: View {
    let key: String
    // init play = 1, following play = 0
    let autoplay:Int
    @State private var player: AVPlayer? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoading = false

    var body: some View {
        ZStack {
            // Video fills the whole screen when ready
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            }
            // Loading and error overlays, centered
            if isLoading {
                Color.black.opacity(0.6).ignoresSafeArea()
                ProgressView("加载播放地址中... (Loading video URL...)")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(16)
            } else if let errorMessage = errorMessage {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.yellow)
                    Text(errorMessage)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(16)
            }
        }
        .onAppear {
            fetchPlayURL()
        }
        .onDisappear {
            player?.pause()
        }
    }

    private func fetchPlayURL() {
        isLoading = true
        errorMessage = nil
        PlayURLService.shared.fetchPlayURL(for: key, autoplay: autoplay) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let playInfo):
                    var playURL: String? = nil
                    if let clarities = playInfo?.clarity {
                        // 1. Find the clarity with description == "auto"
                        if let autoClarity = clarities.first(where: {
                            $0.description == "auto"
                        }) {
                            playURL = autoClarity.path?.result
                        }
                        // 2. If not found, find the highest bitrate with a valid path
                        if playURL == nil {
                            let sorted = clarities.sorted {
                                ($0.bitrate ?? 0) > ($1.bitrate ?? 0)
                            }
                            if let best = sorted.first(where: {
                                ($0.path?.rtmp?.isEmpty == false)
                            }) {
                                playURL = best.path?.result
                            }
                        }
                        // 3. Fallback: use the first available one
                        if playURL == nil {
                            playURL = clarities.first?.path?.result
                        }
                    }
                    let updatedURL = PlayURLService.shared.mapPlayUrl(for: playURL)
                    
                    if let urlString = updatedURL,
                        let url = URL(string: urlString), !urlString.isEmpty
                    {
                        debugPrint("[PlayerView] Playing URL: \(urlString)")
                        let avPlayer = AVPlayer(url: url)
                        player = avPlayer
                        avPlayer.play()
                    } else {
                        errorMessage = "无法获取播放地址 (No valid playback URL found)"
                    }
                case .failure(let error):
                    errorMessage = "加载失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
