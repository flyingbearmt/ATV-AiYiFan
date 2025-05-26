import SwiftUI

struct GalleryView: View {
    @StateObject private var groupVM = GroupListViewModel()
    @StateObject private var genreVM = GenreListViewModel()
    @StateObject private var movieListVM = MovieListViewModel()

    @State private var selectedGroup: Group?
    @State private var selectedGenre: GenreItem?
    @State private var navPath = NavigationPath()

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
            NavigationStack(path: $navPath) {
                if let genre = selectedGenre {
                    MovieListView(
                        movieVM: movieListVM,
                        selectionGenre: $selectedGenre,
                    )
                } else {
                    Text("请选择分组")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: selectedGroup) { oldGroup, newGroup in
            if let group = newGroup {
                genreVM.loadGenres(forGroup: group)
                selectedGenre = nil
                genreVM.isLoading = false
            }
        }
        .onChange(of: selectedGenre) { oldGenre, newGenre in
            navPath = NavigationPath()
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
                NavigationLink(value: group) {
                    Label(group.name, systemImage: group.imageTag)
                        .tag(group)
                }
            }
        }
        .navigationTitle("板块分类")
    }
}
