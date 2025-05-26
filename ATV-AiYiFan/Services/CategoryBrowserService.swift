import Foundation

struct CategoryBrowserResponse: Codable {
    let ret: Int
    let data: CategoryBrowserData?
    let msg: String?
    let debug: String?
}

struct CategoryBrowserData: Codable {
    let code: Int
    let msg: String?
    let info: [CategoryBrowserInfo]?
}

struct CategoryBrowserInfo: Codable {
    let recordcount: Int
    let result: [CategoryBrowserItem]
    let maxpage: Int?
    let fmdata: FMData?
}

struct FMData: Codable {
    let rate: Int?
    let fminfo: [String: String]?
}

struct CategoryBrowserItem: Codable {
    let atypeName: String?
    let videoClassID: String?
    let image: String?
    let key: String?
    let lang: String?
    let cid: String?
    let lastName: String?
    let isShowTodayNum: Bool?
    let title: String?
    let hot: Int?
    let rating: String?
    let year: Int?
    let regional: String?
    let addTime: String?
    let directed: String?
    let starring: String?
    let shareCount: Int?
    let dd: Int?
    let dc: Int?
    let comments: Int?
    let favoriteCount: Int?
    let contxt: String?
    let isSerial: Bool?
    let updateweekly: String?
    let cidMapper: String?
    let lastKey: String?
    let recommended: Bool?
    let updates: Int?
    let tags: String?
    let isFilm: Bool?
    let isDocumentry: Bool?
    let labels: String?
    let charge: Int?
    let vipResource: String?
    let sNo: String?
    let serialCount: Int?
    let score: String?
    let isFix: Bool?
}

class CategoryBrowserService {

    static let shared = CategoryBrowserService()
    private init() {}

    func fetchCategoryItems(
        forPath path: String,
        completion: @escaping (Result<[CategoryBrowserItem], Error>) -> Void
    ) {
        // Construct the URL based on the path (you may need to adjust this for your API)
        let querySting =
            "cinema=1&page=1&size=36&orderby=0&desc=1&cid=\(path)&isserial=-1&isIndex=-1&isfree=-1"
        debugPrint(querySting)
        let urlString = ServiceConstants().getQueryUrl(
            queryParamString: querySting,
            basePathType : "search"
        )
        debugPrint(urlString)
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
                    CategoryBrowserResponse.self,
                    from: data
                )
                let items = decoded.data?.info?.flatMap { $0.result } ?? []
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
