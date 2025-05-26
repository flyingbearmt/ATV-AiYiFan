import SwiftUI

struct VideoDetailView: View {
    let videoId: String
    @StateObject private var viewModel = VideoDetailViewModel()

    var body: some View {
        VStack(spacing: 32) {
            if viewModel.isLoading {
                ProgressView("加载播放信息中... (Loading play info...)")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if let detail = viewModel.videoDetail,
                let playKey = detail.key
            {
                NavigationLink(
                    destination: PlayerView(key: playKey)
                ) {
                    Text(detail.title)
                        .font(.largeTitle)
                        .padding(.top, 16)
                }
            } else if let detail = viewModel.videoDetail {
                Text("无法获取播放Key (No play key found)")
                    .foregroundColor(.secondary)
                Text(detail.title)
                    .font(.largeTitle)
                    .padding(.top, 16)
            } else {
                Text("播放信息未加载 (Play info not loaded)")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .onAppear {
            viewModel.loadVideoDetail(videoId: videoId)
        }
        .padding()
        .navigationTitle(viewModel.videoDetail?.title ?? "Video")
    }
}
