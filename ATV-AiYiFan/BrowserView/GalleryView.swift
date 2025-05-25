import SwiftUI

struct GalleryView: View {
    @StateObject private var groupVM = GroupListViewModel()
    @StateObject private var genreVM = GenreListViewModel()
    @StateObject private var movieVM = MovieListViewModel()
    
    @State private var selectedGroup: Group?
    @State private var selectedGenre: GenreItem?
    
    var body: some View {
        NavigationSplitView {
            SideGroupView(
                groups: groupVM.groups,
                selection: $selectedGroup
            )
        } content: {
           GenreView(
            selectionGroup:$selectedGroup,
            genres: genreVM.genres,
            selectionGenre: $selectedGenre,
            isLoading: genreVM.isLoading,
            errorMessage: genreVM.errorMessage
           )
        } detail: {
            // Column 3: Movies
            if movieVM.isLoading {
                ProgressView("加载影片中...")
            } else if let error = movieVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(movieVM.movies, id: \.key) { movie in
                    NavigationLink(destination: VideoDetailView(videoId: movie.key ?? "")) {
                        HStack(spacing: 16) {
                            if let imageUrl = movie.image, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 120)
                                        .cornerRadius(8)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 80, height: 120)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(movie.title ?? "无标题")
                                    .font(.headline)
                                Text(movie.regional ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .navigationTitle(selectedGenre?.name ?? "影片")
            }
        } .onAppear {
            // Only inject mock data for DEBUG/testing
            genreVM.genres = [
                GenreItem(id: "0,1,3,19", name: "喜剧", path: "/list/movie-19"),
                GenreItem(id: "0,1,3,21", name: "动作", path: "/list/movie-21")
            ]
            movieVM.movies = [
                CategoryBrowserItem(atypeName: "电影", videoClassID: "0,1,3,19", image: "https://via.placeholder.com/80x120.png?text=Movie1", key: "ZIv1XsdbQH2", lang: "中文", cid: "喜剧", lastName: "01", isShowTodayNum: false, title: "测试电影1", hot: 100, rating: "9.0", year: 2024, regional: "中国", addTime: "2024-01-01", directed: "导演A", starring: "演员A,演员B", shareCount: 1, dd: 1, dc: 1, comments: 1, favoriteCount: 1, contxt: "简介1", isSerial: false, updateweekly: "", cidMapper: "喜剧", lastKey: "", recommended: false, updates: 0, tags: nil, isFilm: true, isDocumentry: false, labels: "", charge: 0, vipResource: "1080P", sNo: "", serialCount: 0, score: "9.0", isFix: false)
            ]
            
            if selectedGroup == nil, let first = groupVM.groups.first {
                   selectedGroup = first
               }
        }
        .navigationTitle("分类 (Categories)")
    }
}

struct SideGroupView: View {
    let groups: [Group]
    @Binding var selection: Group?

    var body: some View {
        List(selection: $selection) {
            ForEach(groups) { group in
                NavigationLink(value: group.name) {
                    Label(group.name, systemImage: group.imageTag)
                }
            }
        }
        .navigationTitle("分类")
    }
}



