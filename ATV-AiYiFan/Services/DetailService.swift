import Foundation

struct VideoDetailResponse: Codable {
    let ret: Int
    let data: VideoDetailData?
    let msg: String?
    let debug: String?
}

struct VideoDetailData: Codable {
    let code: Int
    let msg: String?
    let info: [VideoDetail]?
}

struct VideoDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let contxt: String?
    let imgPath: String?
    let add_date: String?
    let addTime: String?
    let post_Year: String?
    let channel: String?
    let videoType: String?
    let updateweekly: String?
    let comments: Int?
    let isVideoFavrited: Bool?
    let taxis: Int?
    let unlockGold: Int?
    let playRecordURL: String?
    let favoriteCount: Int?
    let filterGold: Int?

    // this will be the id to get the play url
    let key: String?
    let cid: String?
    let commentStatus: Int?
    let shareCount: Int?
    let pinfenRate: Double?
    let renqiRate: Double?
    let view: Int?
    let good: Int?
    let bad: Int?
    let publisher: Publisher?
    let stars: [String]?
    let directors: [String]?
    let language: String?
    let regional: String?
    let publishNavKey: String?
    let isMediaTitleVisible: Bool?
    let isSerial: Bool?
    let cidMapper: String?
    let likeStatus: Int?
    let tags: [String]?
    let mixAttr: String?
    let source: Int?
    let vipSource: Int?
    let masaike: Bool?
    let extraList: [ExtraListItem]?
    let sNo: String?
    let keyWord: String?
    let serialCount: Int?
    let lastName: String?
    let isFree: Bool?
    let score: String?
    let isWide: Bool?
    let watchTimeout: Int?
}

struct Publisher: Codable {
    let uid: Int?
    let title: String?
    let avatar: String?
    let videoCount: Int?
    let gid: Int?
    let key: String?
    let fansCount: Int?
    let hot: Int?
    let slogon: String?
    let gender: Int?
    let userLevel: Int?
    let userKey: String?
    let from: String?
    let isUP: Bool?
    let sign: String?
    let likes: Int?
    let isOfficalUP: Bool?
    let isAttend: Bool?
}

struct ExtraListItem: Codable {
    let position: String?
    let linkUrl: String?
    let rawImage: String?
    let adLevel: Int?
}

class DetailService {
    static let shared = DetailService()
    private init() {}

    func fetchDetail(id: String) async throws -> VideoDetail? {
        let urlString =
            "https://m10.yfsp.tv/v3/video/detail?cinema=1&device=1&player=CkPlayer&tech=HLS&country=HU&lang=cns&v=1&id=\(id)&region=US&vv=a3bde195a4b819f6d6cfd5ed5322b577&pub=CJSqDpWtCparC2utEJTVLLDVDZWkCJarBZ4oE2upCLySCJAR6fWn73CQifYQCPeo734o6viO732QcHcQ6HWQ6QzPZ4oOpHaOp8oOp8vC3OrOMHZP68mP65YC3TZDcPYOc2"
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(
            VideoDetailResponse.self,
            from: data
        )
        return decoded.data?.info?.first
    }

    // For non-async/await usage:
    func fetchDetail(
        id: String,
        completion: @escaping (Result<VideoDetail?, Error>) -> Void
    ) {
        let urlString =
            "https://m10.yfsp.tv/v3/video/detail?cinema=1&device=1&player=CkPlayer&tech=HLS&country=HU&lang=cns&v=1&id=\(id)&region=US&vv=a3bde195a4b819f6d6cfd5ed5322b577&pub=CJSqDpWtCparC2utEJTVLLDVDZWkCJarBZ4oE2upCLySCJAR6fWn73CQifYQCPeo734o6viO732QcHcQ6HWQ6QzPZ4oOpHaOp8oOp8vC3OrOMHZP68mP65YC3TZDcPYOc2"
        guard let url = URL(string: urlString) else {
            completion(.success(nil))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.success(nil))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(
                    VideoDetailResponse.self,
                    from: data
                )
                completion(.success(decoded.data?.info?.first))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
