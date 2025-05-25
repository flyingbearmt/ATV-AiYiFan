// MovieListViewModel.swift
import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [CategoryBrowserItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let categoryBrowserService: CategoryBrowserService

    init(categoryBrowserService: CategoryBrowserService = .shared) {
        self.categoryBrowserService = categoryBrowserService
    }

    func loadMovies(forGenre genre: GenreItem) {
        let path = genre.path

        isLoading = true
        errorMessage = nil
        categoryBrowserService.fetchCategoryItems(forPath: path) {
            [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let items):
                    self?.movies = items
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct MovieItem: Identifiable, Hashable {
    let id: String
    let name: String
}
