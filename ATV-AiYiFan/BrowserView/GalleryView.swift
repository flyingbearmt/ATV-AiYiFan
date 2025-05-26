import SwiftUI

struct GalleryView: View {
    @StateObject private var groupVM = GroupListViewModel()
    @StateObject private var genreVM = GenreListViewModel()
    @StateObject private var movieVM = MovieListViewModel()

    @State private var selectedGroup: Group?
    @State private var selectedGenre: GenreItem?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationSplitView {
            SideGroupView(
                groups: groupVM.groups,
                selection: $selectedGroup
            )
        } content: {
            // Second column: Genres
            if let group = selectedGroup {
                GenreView(
                    selectionGroup: $selectedGroup,
                    genres: genreVM.genres,
                    selectionGenre: $selectedGenre,
                    isLoading: genreVM.isLoading,
                    errorMessage: genreVM.errorMessage
                )

            } else {
                Text("请选择分组")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
        } detail: {
            MovieListView(movieVM: movieVM, selectedGenre: selectedGenre)
        
        }.navigationSplitViewStyle(.balanced)
            .onChange(of: selectedGroup) { oldGroup, newGroup in
                print(
                    "[DEBUG] selectedGroup changed from \(String(describing: oldGroup)) to \(String(describing: newGroup))"
                )
                if let group = newGroup {
                    genreVM.loadGenres(forGroup: group)
                    selectedGenre = nil
                    genreVM.isLoading = false
                }
            }.onAppear {
                print(
                    "[DEBUG] GalleryView appeared. selectedGroup: \(String(describing: selectedGroup)), selectedGenre: \(String(describing: selectedGenre))"
                )
                // Only inject mock data for DEBUG/testing
                genreVM.genres = [
                    GenreItem(
                        id: "0,1,3,19",
                        name: "喜剧",
                        path: "/list/movie-19"
                    ),
                    GenreItem(
                        id: "0,1,3,21",
                        name: "动作",
                        path: "/list/movie-21"
                    ),
                ]
                genreVM.isLoading = false
                genreVM.errorMessage = nil
                movieVM.movies = [
                    CategoryBrowserItem(
                        atypeName: "电影",
                        videoClassID: "0,1,3,19",
                        image: "",
                        key: "ZIv1XsdbQH2",
                        lang: "中文",
                        cid: "喜剧",
                        lastName: "01",
                        isShowTodayNum: false,
                        title: "测试电影1",
                        hot: 100,
                        rating: "9.0",
                        year: 2024,
                        regional: "中国",
                        addTime: "2024-01-01",
                        directed: "导演A",
                        starring: "演员A,演员B",
                        shareCount: 1,
                        dd: 1,
                        dc: 1,
                        comments: 1,
                        favoriteCount: 1,
                        contxt: "简介1",
                        isSerial: false,
                        updateweekly: "",
                        cidMapper: "喜剧",
                        lastKey: "",
                        recommended: false,
                        updates: 0,
                        tags: nil,
                        isFilm: true,
                        isDocumentry: false,
                        labels: "",
                        charge: 0,
                        vipResource: "1080P",
                        sNo: "",
                        serialCount: 0,
                        score: "9.0",
                        isFix: false
                    )
                ]
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
                Label(group.name, systemImage: group.imageTag)
                    .tag(group)
            }
        }
        .navigationTitle("板块分类")
    }
}
