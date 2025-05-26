import SwiftUI

struct VideoDetailHost: View {
    let videoId: String
    @StateObject private var viewModel = VideoDetailViewModel()

    var body: some View {
        VStack(spacing: 32) {
            if viewModel.isLoading {
                ProgressView("加载播放信息中... (Loading play info...)")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if let detail = viewModel.videoDetail
            {
                VideoDetailView(
                    videoDetail: detail
                )
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

struct VideoDetailView: View {
    let videoDetail: VideoDetailUI

    var body: some View {
        ScrollView {
            // Poster and title overlay
            HStack(alignment: .bottom, spacing: 20) {
                // Poster
                AsyncImage(url: URL(string: videoDetail.posterURL ?? "")) {
                    image in
                    image
                        .resizable()
                        .aspectRatio(2 / 3, contentMode: .fit)
                        .frame(height: 220)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 220)
                }

                // Title and metadata
                VStack(alignment: .leading, spacing: 8) {
                    Text(videoDetail.title ?? "Loading...")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)

                    HStack(spacing: 16) {
                        if let year = videoDetail.postYear {
                            Text(String(year))
                                .font(.subheadline)
                        }

                        if let rating = videoDetail.rating {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", rating))
                                    .font(.subheadline)
                            }
                        }
                    }
                    .foregroundColor(.secondary)

                    // Action buttons
//                    HStack(spacing: 20) {
//                        Button(action: { /* Play action */  }) {
//                            HStack {
//                                Image(systemName: "play.fill")
//                                Text("Play")
//                            }
//                            .padding(.horizontal, 24)
//                            .padding(.vertical, 12)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                        }
//
//                        Button(action: { /* Add to list action */  }) {
//                            Image(systemName: "plus")
//                                .padding(12)
//                                .background(Color.gray.opacity(0.3))
//                                .clipShape(Circle())
//                        }
//                    }
//                    .padding(.top, 8)
                    if let playKey = videoDetail.playKey{
                        NavigationLink(
                            destination: PlayerView(key: playKey)
                        ) {
                            Text(videoDetail.title)
                                .font(.largeTitle)
                                .padding(.top, 16)
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.trailing, 20)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }

        // Description
        if let overview = videoDetail.overviewDescription {
            VStack(alignment: .leading, spacing: 8) {
                Text("Overview")
                    .font(.headline)
                Text(overview)
                    .font(.body)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
    }
}
extension VideoDetailUI {
    public static let mockVideoDetail = VideoDetailUI(
        id: 12345,
        title: "The Great Adventure",
        postYear: "2023",
        rating: "8.5",
        overviewDescription:
            "In a world where dreams become reality, a group of unlikely heroes must band together to save their city from an ancient evil that threatens to consume all of reality as we know it. With stunning visuals and heart-pounding action, this is the adventure of a lifetime.",
        posterURL: "/d5NXSklXo0qyIYkgV94XAgMIckC.jpg",
        genres: "Action,Adventure,Sci-Fi",
        director: "Jane Smith",
        cast: ["John Doe", "Jane Smith", "Alex Johnson", "Maria Garcia"],
        playKey: "abc123xyz"
    )
}

struct VideoDetailView_Previews: PreviewProvider {

    static var previews: some View {
        VideoDetailView(videoDetail: .mockVideoDetail)
    }
}
