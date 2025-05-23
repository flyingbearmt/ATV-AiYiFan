import SwiftUI
import AVKit

struct PlayerView: View {
    let video: PlayURLInfo
    @State private var player: AVPlayer
    
    init(video: PlayURLInfo) {
        self.video = video
        
        let videourl = video.clarity.first?.path?.result ?? " "
        _player = State(initialValue: AVPlayer(url: URL(string: videourl)!))
    }
    
    var body: some View {
        VStack(spacing: 32) {
            VideoPlayer(player: player)
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(16)
                .frame(maxWidth: 900)
            // Detail Section
//            VStack(alignment: .leading, spacing: 8) {
//                Text(video.title)
//                    .font(.largeTitle)
//                    .padding(.bottom, 4)
//        
//                Text(video.title)
//                        .font(.body)
//                        .foregroundColor(.secondary)
//            
//            }
            Spacer()
        }
        .padding()
        .onDisappear {
            player.pause()
        }
    }
}
