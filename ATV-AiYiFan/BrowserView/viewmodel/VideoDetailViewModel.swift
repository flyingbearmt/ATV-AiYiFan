import Combine
import Foundation

class VideoDetailViewModel: ObservableObject {
    @Published var videoDetail: VideoDetailUI? = nil
    @Published var serialList: [SerialListItemUI]? = nil
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
        detailService.fetchDetail(movieKey: videoId) { [weak self] result in
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

    func loadVideoSerials(videoId: String, genreKey: String) {
        isLoading = true
        errorMessage = nil
        detailService.fetchSeries(
            movieKey: videoId,
            genreKey: genreKey
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.serialList = detail.map { item in
                        SerialListItemUI(from: item)
                    }
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
    let playKey: String?  // For video playback
    let isSerial: Bool
    let genreKey: String
    let taxis: Int
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
        self.isSerial = detail.isSerial ?? false
        self.genreKey = detail.cid ?? "0,1,3"
        self.taxis = detail.taxis ?? 0
    }
}

struct SerialListItemUI: Identifiable, Codable {
    let id: Int
    let name: String?
    let playKey: String?
}

extension SerialListItemUI {
    init(from playItem: PlayListItem) {
        self.id = playItem.id
        self.name = playItem.name
        self.playKey = playItem.key
    }
}
