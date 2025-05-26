import Foundation
import Combine

class VideoDetailViewModel: ObservableObject {
    @Published var videoDetail: VideoDetailUI? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let detailService: DetailService
    private var cancellables = Set<AnyCancellable>()
    
    init(detailService: DetailService = .shared) {
        self.detailService = detailService
    }
    
    func loadVideoDetail(videoId: String) {
        isLoading = true
        errorMessage = nil
        detailService.fetchDetail(movieKey : videoId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.videoDetail = VideoDetailUI(from: detail)
                case .failure(let error):
                    self?.errorMessage = "加载失败: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct VideoDetailUI: Identifiable, Codable {
    let id: Int
    let title: String
    let postYear: String?
    let rating: String?
    let overviewDescription: String?
    let posterURL: String?
    let genres: String?
    let director: String?
    let cast: [String]?
    let playKey: String? // For video playback
}

// Helper extension for VideoDetailUI
extension VideoDetailUI {
    // Initialize from VideoDetail
    init(from detail: VideoDetail) {
        self.id = detail.id
        self.title = detail.title
        self.postYear = detail.post_Year
        self.rating = detail.score
        self.overviewDescription = detail.contxt
        self.posterURL = detail.imgPath
        self.genres = detail.cidMapper
        self.director = detail.directors?.first
        self.cast = detail.stars?.map { $0.lowercased() }
        self.playKey = detail.key
    }
}
