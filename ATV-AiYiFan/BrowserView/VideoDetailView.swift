import SwiftUI

struct VideoDetailHost: View {
    let videoId: String
    let genreId: String
    @StateObject private var viewModel = VideoDetailViewModel()

    var body: some View {
        VStack(spacing: 32) {
            if viewModel.isLoading {
                ProgressView("加载播放信息中... (Loading play info...)")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if let detail = viewModel.videoDetail {
                VideoDetailView(
                    videoDetail: detail,
                    serial: viewModel.serialList
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
        }
        .onAppear {
            viewModel.loadVideoDetail(videoId: videoId)
            viewModel.loadVideoSerials(videoId: videoId, genreKey: genreId)
        }
        .padding(.top, 70)
        .navigationTitle(viewModel.videoDetail?.title ?? "Video")
    }
}

struct VideoDetailView: View {
    let videoDetail: VideoDetailUI
    let serial: [SerialListItemUI]?

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            // Poster and title overlay
            HStack(alignment: .top, spacing: 20) {
                // Poster
                AsyncImage(url: URL(string: videoDetail.posterURL ?? "")) {
                    image in
                    image
                        .resizable()
                        .aspectRatio(2 / 3, contentMode: .fit)
                        .frame(height: 400)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 300, height: 400)
                }

                // Title and metadata
                VStack(alignment: .leading, spacing: 24) {
                    Text(videoDetail.title)
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
                                Text(rating)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .foregroundColor(.secondary)
                    if let playKey = videoDetail.playKey {
                        NavigationLink(
                            destination: PlayerView(key: playKey, autoplay: 1)
                        ) {
                            Text("开始播放")
                                .font(.largeTitle)
                                .padding(.top, 16)
                        }
                    }

                    // Description
                    if let overview = videoDetail.overviewDescription {
                        VStack(alignment: .leading) {
                            Text("Overview")
                                .font(.headline)
                            Text(overview)
                                .font(.body)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            // serials
            if let episodes = serial, !episodes.isEmpty {
                SerialView(episodes: episodes)
                    .padding(.top, 8)
            }
        }
    }

    struct SerialView: View {

        // Adjust columns as needed for your UI
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]

        let episodes: [SerialListItemUI]

        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(episodes) { episode in
                        NavigationLink(
                            destination: PlayerView(
                                key: episode.playKey ?? "",
                                autoplay: 0
                            )
                        ) {
                            Text(episode.name ?? "")
                        }
                    }
                }
            }
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
        playKey: "abc123xyz",
        isSerial: true,
        genreKey: "1,3,4",
        taxis: 0
    )
}

extension SerialListItemUI {
    public static let mockSerialListUI = SerialListItemUI(
        id: 0,
        name: "hhhhh",
        playKey: "1,3,4"
    )
}

struct VideoDetailView_Previews: PreviewProvider {

    static var previews: some View {
        VideoDetailView(
            videoDetail: .mockVideoDetail,
            serial: [.mockSerialListUI]
        )
    }
}
