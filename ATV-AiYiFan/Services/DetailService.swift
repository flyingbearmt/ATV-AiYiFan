import Foundation

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
    // here to load serials
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

struct PlayListInfo: Codable {
    let pageSize: Int
    let playList: [PlayListItem]
    let playListType: String
}

struct PlayListItem: Codable, Identifiable {
    let id: Int
    let key: String
    let name: String
    let updateDate: String
    let isBought: Bool
    let isNew: Bool
    let imgPath: String?
    let publishdate: String
    let sharpness: String?
    let isLive: Bool
    let isFix: Bool
}

class DetailService {
    static let shared = DetailService()
    private init() {}

    // For non-async/await usage:
    func fetchDetail(
        movieKey: String,
        completion: @escaping (Result<VideoDetail, Error>) -> Void
    ) {
        let querySting =
            "cinema=1&device=1&player=CkPlayer&tech=HLS&country=HU&lang=cns&v=1&id=\(movieKey)&region=US"

        let urlString = ServiceConstants().getQueryUrl(
            queryParamString: querySting,
            basePathType: "videodetail"
        )

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(
                    BaseResponse<VideoDetail>.self,
                    from: data
                )
                completion(.success((decoded.data.info.first)!))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // For non-async/await usage:
    func fetchSeries(
        movieKey: String,
        genreKey: String,
        completion: @escaping (Result<[PlayListItem], Error>) -> Void
    ) {
        let querySting =
            "cinema=1&vid=\(movieKey)&lsk=1&taxis=1&cid=\(genreKey)"

        let urlString = ServiceConstants().getQueryUrl(
            queryParamString: querySting,
            basePathType: "seriesList"
        )

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(
                    BaseResponse<PlayListInfo>.self,
                    from: data
                )
                completion(.success((decoded.data.info.first?.playList)!))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
