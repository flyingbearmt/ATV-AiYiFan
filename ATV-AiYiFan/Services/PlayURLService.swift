import Foundation

struct PlayURLResponse: Codable {
    let ret: Int
    let data: PlayURLData?
    let msg: String?
    let debug: String?
}

struct PlayURLData: Codable {
    let code: Int
    let msg: String?
    let info: [PlayURLInfo]?
}

struct PlayURLInfo: Codable {
    let flvPathList: [FlvPath]?
    let key: String?
    let playingMedia: PlayingMedia?
    let customData: CustomData?
    let tracks: [String]?
    let pauseData: [FlvPath]?
    let startData: [String]?
    let barrageData: [String]?
    let videoServer: VideoServer?
    let previewFormat: String?
    let uniqueKey: String?
    let clarity: [Clarity]
    let mediaTitle: String?
    let mediaKey: String?
    let startSecond: Int?
    let isLine: Bool?
    let maxFrontAds: Int?
    let isUserFilterAd: Bool?
    let isPreView: Bool?
    let isLimitedStream: Bool?
    let barrageStatus: Int?
    let needLogin: Int?
}

struct FlvPath: Codable {
    let isHls: Bool?
    let result: String?
    let dashResult: String?
    let validator: String?
    let type: Int?
    let link: String?
    let broker: String?
    let backup: String?
    let rtmp: String?
    let needSign: Bool?
    let isLive: Bool?
    let bitrate: Int?
}

struct PlayingMedia: Codable {
    let key: String?
    let title: String?
}

struct CustomData: Codable {
    let s: Int?
    let e: Int?
    let t: Int?
    let v: String?
    let b: Int?
    let w: Int?
    let l: Bool?
}

struct VideoServer: Codable {
    let status: Int?
    let info: String?
    let isMp4Available: Bool?
}

struct Clarity: Codable {
    let bitrate: Int?
    let title: String?
    let isBought: Bool?
    let key: String?
    let description: String?
    let isVIP: Bool?
    let isEnabled: Bool?
    let isNav: Bool?
    let id: Int?
    let path: FlvPath?
    let memo: String?
    let uniqueID: Int?
    let line: Int?
}

class PlayURLService {
    static let shared = PlayURLService()
    private init() {}

    func fetchPlayURL(for id: String) async throws -> PlayURLInfo? {
        let urlString =
            "https://m10.yfsp.tv/v3/video/play?cinema=1&id=\(id)&a=1&lang=none&usersign=1&region=US&device=1&isMasterSupport=1"
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(PlayURLResponse.self, from: data)
        return decoded.data?.info?.first
    }

    func fetchPlayURL(
        for id: String,
        completion: @escaping (Result<PlayURLInfo?, Error>) -> Void
    ) {
        let querySting = "cinema=1&id=\(id)&a=1&lang=none&usersign=1&region=US&device=1&isMasterSupport=1"
        
        let urlString = ServiceConstants().getQueryUrl(
            queryParamString: querySting,
            basePathType: "videoplay"
        )
        
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
                    PlayURLResponse.self,
                    from: data
                )
                completion(.success(decoded.data?.info?.first))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
