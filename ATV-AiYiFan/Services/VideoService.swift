import Foundation

class VideoService {
    static func fetchVideos(completion: @escaping ([VideoItem]) -> Void) {
        // TODO: Replace with real API call
        // Simulate network delay and mock data
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let mockVideos = [
                VideoItem(id: "1", title: "Sample Video 1", thumbnailURL: URL(string: "https://via.placeholder.com/300x170.png?text=Video+1")!, videoURL: URL(string: "https://www.example.com/video1.mp4")!),
                VideoItem(id: "2", title: "Sample Video 2", thumbnailURL: URL(string: "https://via.placeholder.com/300x170.png?text=Video+2")!, videoURL: URL(string: "https://www.example.com/video2.mp4")!),
                VideoItem(id: "3", title: "Sample Video 3", thumbnailURL: URL(string: "https://via.placeholder.com/300x170.png?text=Video+3")!, videoURL: URL(string: "https://www.example.com/video3.mp4")!)
            ]
            completion(mockVideos)
        }
    }
}
