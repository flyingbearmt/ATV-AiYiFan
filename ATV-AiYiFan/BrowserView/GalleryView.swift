import SwiftUI

struct GalleryView: View {
    @State private var categories: [CategoryItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        Group {
            if isLoading {
                ProgressView("加载分类中... (Loading categories...)")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                
                NavigationSplitView{
                    // category
                } detail: {
                    // movie browser view
                }
                List(categories, id: \ .path) { category in
                    NavigationLink(destination: CategoriesView(path: category.path)) {
                        HStack {
                            Text(category.label)
                                .font(.title2)
                            Spacer()
                            if category.isHot {
                                Text("🔥")
                            }
                            if category.isNew {
                                Text("🆕")
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .onAppear {
            fetchCatefories()
        }
        .navigationTitle("分类 (Categories)")
    }
    
    private func fetchCatefories(){
        CategoryService.shared.fetchCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.categories = items
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "加载失败: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

