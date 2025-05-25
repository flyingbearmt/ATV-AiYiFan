import Foundation

struct CategoryResponse: Codable {
    let ret: Int
    let data: CategoryData?
    let msg: String?
    let debug: String?
}

struct CategoryData: Codable {
    let code: Int
    let msg: String?
    let info: [CategoryItem]?
}

struct CategoryItem: Codable {
    let label: String
    let link: String
    let notifications: Int
    let category: String?
    let external: Bool
    let params: [String: String]?
    let path: String
    let isNew: Bool
    let image: String?
    let isHot: Bool
}

class CategoryService {
    static let shared = CategoryService()
    private init() {}

    func fetchCategories(
        completion: @escaping (Result<[CategoryItem], Error>) -> Void
    ) {
        let urlString =
            "https://m10.yfsp.tv/v3/list/mainMenuv2?cinema=1&cid=0,1,3&cacheable=1"
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
                    CategoryResponse.self,
                    from: data
                )
                let categories = decoded.data?.info ?? []
                completion(.success(categories))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Placeholder for the original fetchVideos method
    func fetchVideos(completion: @escaping ([VideoItem]) -> Void) {
        // TODO: Implement real video fetching logic
    }
}
