import SwiftUI

struct MovieListView: View {
    @ObservedObject var movieVM: MovieListViewModel
    @Binding var selectionGenre: GenreItem?

    // Adjust columns as needed for your UI
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ScrollView {
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
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(movieVM.movies, id: \.key) { movie in
                        NavigationLink(
                            destination: VideoDetailHost(
                                videoId: movie.key ?? "",
                                genreId: movie.videoClassID ?? ""
                            )
                        ) {
                            MovieThumnail(movie: movie)
                                .padding(.bottom, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle(selectionGenre?.name ?? "影片")
        .onChange(of: selectionGenre) { old, newGenre in
            if let genre = newGenre {
                movieVM.loadMovies(forGenre: genre)
            }
        }.onAppear {
            if let genre = selectionGenre {
                movieVM.loadMovies(forGenre: genre)
            }
        }
    }
}

struct MovieThumnail: View {
    let movie: CategoryBrowserItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster
            AsyncImage(url: URL(string: movie.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 220)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 160, height: 220)
                    .cornerRadius(8)
            }

            // Title
            Text(movie.title ?? "无标题")
                .font(.headline)
                .lineLimit(1)

            // Subtitle (e.g., genre or year)
            Text(movie.atypeName ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)

            // Rating
            if let rating = movie.rating {
                Text(rating)
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
    }
}
