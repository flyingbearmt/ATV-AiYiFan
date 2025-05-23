import SwiftUI

struct GalleryView: View {
    @State private var videos: [VideoItem] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading videos...")
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 40)], spacing: 40) {
                        ForEach(videos) { video in
                            NavigationLink(destination: VideoDetailView(video: video)) {
                                VStack {
                                    AsyncImage(url: video.thumbnailURL) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(16)
                                    } placeholder: {
                                        Rectangle().fill(Color.gray.opacity(0.3))
                                            .frame(height: 170)
                                    }
                                    Text(video.title)
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                        .padding(.top, 8)
                                }
                                .frame(width: 300)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            VideoService.fetchVideos { fetched in
                DispatchQueue.main.async {
                    self.videos = fetched
                    self.isLoading = false
                }
            }
        }
        .navigationTitle("Gallery")
    }
}
