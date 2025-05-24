// GenreListViewModel.swift
import Foundation

class GenreListViewModel: ObservableObject {
    @Published var genres: [GenreItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let categoryService: CategoryService
    
    init(categoryService: CategoryService = .shared) {
        self.categoryService = categoryService
    }
    
    func loadGenres(forGroup group: Group) {
        isLoading = true
        errorMessage = nil
        categoryService.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let items):
                    self?.genres = items.map { GenreItem(id: $0.path, name: $0.label, path: $0.path) }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


struct GenreItem: Identifiable, Hashable {
    let id: String
    let name: String
    let path: String
}
