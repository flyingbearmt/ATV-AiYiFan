import SwiftUI

struct GenreView: View {
    @Binding var selectionGroup: Group?
    let genres: [GenreItem]
    @Binding var selectionGenre: GenreItem?
    let isLoading: Bool
    let errorMessage: String?

    var body: some View {
        if isLoading {
            ProgressView("\(selectionGroup?.name ?? "") 加载中...")
        } else if let error = errorMessage {
            Text(error)
                .foregroundColor(.red)
                .padding()
        } else {
            List(selection: $selectionGenre) {
                ForEach(genres) { genre in
                    Text(genre.name)
                        .tag(genre)
                }
            }
            .navigationTitle("选择分类")
        }
    }
}
