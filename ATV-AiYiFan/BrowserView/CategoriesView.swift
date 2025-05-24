import SwiftUI

//this will be the place to display the videos according to category
struct CategoriesView: View {
    let path: String
    @State private var items: [CategoryBrowserItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
//        Group {
//            if isLoading {
//                ProgressView("加载中... (Loading movies...)")
//            } else if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//            } else {
//                List(items, id: \ .key) { item in
//                    HStack(spacing: 16) {
//                        if let imageUrl = item.image, let url = URL(string: imageUrl) {
//                            AsyncImage(url: url) { image in
//                                image.resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 80, height: 120)
//                                    .cornerRadius(8)
//                            } placeholder: {
//                                Rectangle().fill(Color.gray.opacity(0.3))
//                                    .frame(width: 80, height: 120)
//                            }
//                        }
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(item.title ?? "无标题")
//                                .font(.headline)
//                            Text(item.atypeName ?? "")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                        }
//                        Spacer()
//                    }
//                    .padding(.vertical, 8)
//                }
//                .listStyle(.insetGrouped)
//            }
//        }
//        .onAppear {
//            CategoryBrowserService.fetchCategoryItems(forPath: path) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let items):
//                        self.items = items
//                        self.isLoading = false
//                    case .failure(let error):
//                        self.errorMessage = "加载失败: \(error.localizedDescription)"
//                        self.isLoading = false
//                    }
//                }
//            }
//        }
//        .navigationTitle("影片列表 (Movies)")
    }
}
