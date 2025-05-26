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
    let info: [GenreAPIItem]?
}

struct GenreAPIItem: Codable {
    let pid: String
    let className: String
    let taxis: Int
    let isIndex: Bool
    let path: String
    let altLink: String
    let contxt: String
    let postTime: String
    let id: Int
}

class CategoryService {
    static let shared = CategoryService()
    private init() {}

    func fetchCategories(
        groupId: String,
        completion: @escaping (Result<[GenreAPIItem], Error>) -> Void
    ) {
        let querySting = "cinema=1&cid=\(groupId)"
        
        let urlString = ServiceConstants().getQueryUrl(
            querySubPath: "AllVideoType?",
            queryParamString: querySting
        )
        debugPrint(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            do {
                let response = try JSONDecoder().decode(CategoryResponse.self, from: data)
                if let info = response.data?.info {
                    completion(.success(info))
                } else {
                    completion(.failure(NSError(domain: "No info", code: -3)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
