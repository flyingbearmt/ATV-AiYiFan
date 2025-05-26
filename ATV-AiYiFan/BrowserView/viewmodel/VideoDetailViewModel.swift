import Foundation
import Combine

class VideoDetailViewModel: ObservableObject {
    @Published var videoDetail: VideoDetail? = nil
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
                    self?.videoDetail = detail
                case .failure(let error):
                    self?.errorMessage = "加载失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
