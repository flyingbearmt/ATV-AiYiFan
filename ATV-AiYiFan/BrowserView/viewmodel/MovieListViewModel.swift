// MovieListViewModel.swift
import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [CategoryBrowserItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    
    private let categoryBrowserService: CategoryBrowserService
    private var currentGenrePath: String? = nil
    private var currentPage = 1
    
    init(categoryBrowserService: CategoryBrowserService = .shared) {
        self.categoryBrowserService = categoryBrowserService
    }
    
    func loadMovies(forGenre genre: GenreItem) {
        // Reset pagination when loading a new genre
        currentGenrePath = genre.path
        currentPage = 1
        movies = []
        hasMorePages = true
        errorMessage = nil
        
        fetchNextPage()
    }
    
    func loadMoreIfNeeded(currentItem item: CategoryBrowserItem?) {
        // Load more content when user reaches near the end
        guard let item = item, !isLoading, hasMorePages else { return }
        
        // Check if we're near the end of the list (last 5 items)
        let thresholdIndex = movies.count - 5
        if let itemIndex = movies.firstIndex(where: { $0.key == item.key }), 
           itemIndex >= thresholdIndex {
            fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        guard let path = currentGenrePath, hasMorePages, !isLoading else { return }
        
        isLoading = true
        categoryBrowserService.fetchCategoryItems(forPath: path, page: currentPage) {
            [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.movies.append(contentsOf: response.items)
                    self.hasMorePages = response.hasMorePages
                    self.currentPage += 1
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
