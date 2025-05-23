import Foundation

struct VideoItem: Identifiable, Codable {
    let id: String
    let title: String
    let thumbnailURL: URL
}
