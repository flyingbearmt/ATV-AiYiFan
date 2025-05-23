//
//  ATV_AiYiFanApp.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/21/25.
//

import SwiftUI

@main
struct ATV_AiYiFanApp: App {
    var body: some Scene {
        WindowGroup {
            // Provide a mock VideoItem for initial testing
            let mockVideo = VideoItem(
                id: "ZIv1XsdbQH2",
                title: "测试视频 (Test Video)",
                thumbnailURL: URL(string: "https://via.placeholder.com/300x170.png?text=Video")!
            )
            VideoDetailView(videoId: mockVideo.id)
            
        }
    }
}
