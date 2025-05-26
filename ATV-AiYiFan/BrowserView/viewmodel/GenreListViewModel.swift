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
        categoryService.fetchCategories(groupId: group.groupPathId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let items):
                    // Map GenreAPIItem to GenreItem
                    self.genres = items.map {
                        GenreItem(
                            id: String($0.id),
                            name: $0.className,
                            path: $0.path
                        )
                    }
                case .failure(let error):
                    self.errorMessage = "加载失败: \(error.localizedDescription)"
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
