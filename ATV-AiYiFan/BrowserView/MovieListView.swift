import SwiftUI

struct MovieListView: View {
    @ObservedObject var movieVM: MovieListViewModel
    var selectedGenre: GenreItem?

    var body: some View {
        VStack {
            if movieVM.isLoading {
                ProgressView("加载影片中...")
            } else if let error = movieVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if movieVM.movies.isEmpty {
                Text("暂无影片")
                    .foregroundColor(.secondary)
            } else {
                List(movieVM.movies, id: \.key) { movie in
                    HStack {
                        Text(movie.title ?? "无标题")
                            .font(.headline)
                        Spacer()
                        Text(movie.regional ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        // Add more columns as needed
                    }
                }
                .navigationTitle(selectedGenre?.name ?? "影片")
            }
        }
        .onChange(of: selectedGenre) { newGenre in
            if let genre = newGenre {
                debugPrint(genre)
                movieVM.loadMovies(forGenre: genre)
            }
        }
    }
}
