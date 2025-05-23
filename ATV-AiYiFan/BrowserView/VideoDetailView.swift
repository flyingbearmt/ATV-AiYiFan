import SwiftUI
import AVKit

struct VideoDetailView: View {
    let videoId: String
    @State private var videoDetail: VideoDetail? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var navigateToPlayer = false
    @FocusState private var isPlayButtonFocused: Bool

    var body: some View {
        VStack(spacing: 32) {
            if isLoading {
                ProgressView("加载播放信息中... (Loading play info...)")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if let detail = videoDetail, let playKey = detail.key, !playKey.isEmpty {
                NavigationView {
                    NavigationLink(
                        destination: PlayerView(key: playKey),
                        label: {
                            Text("Start to Play")
                                .font(.title2)
                                .padding()
                                .focusable(true)
                        }
                    )
                    
                }
                Text(detail.title)
                    .font(.largeTitle)
                    .padding(.top, 16)
            } else if let detail = videoDetail {
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
            fetchDetail()
        }
        .padding()
        .navigationTitle(videoDetail?.title ?? "Video")
    }

    private func fetchDetail() {
        isLoading = true
        errorMessage = nil
        DetailService.shared.fetchDetail(id: videoId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let info):
                    if let info = info {
                        videoDetail = info
                    } else {
                        errorMessage = "未找到播放信息 (No play info found)"
                    }
                case .failure(let error):
                    errorMessage = "加载失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
