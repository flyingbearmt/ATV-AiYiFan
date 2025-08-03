//
//  ATV_AiYiFanApp.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/21/25.
//

import SwiftUI

@main
struct ATV_AiYiFanApp: App {
    
    @StateObject private var viewModel = HTMLParserViewModel()
    
    var body: some Scene {
        WindowGroup {
            GalleryView().onAppear {
                    viewModel.fetchConfig()
                }
        }
    }
}
