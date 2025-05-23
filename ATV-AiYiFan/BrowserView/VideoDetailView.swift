import SwiftUI
import AVKit

struct VideoDetailView: View {
    let video: VideoItem
    let videoPlayDetail: PlayURLInfo

    var body: some View {
        VStack(spacing: 32) {
            
            NavigationLink(destination: PlayerView(video: videoPlayDetail)){
                Button("Sign In"){
                    
                }
            }
            Text(video.title)
                .font(.largeTitle)
                .padding(.top, 16)
            Spacer()
        }
        .onAppear(perform: {
            let res = PlayURLService.fetchPlayURL(id:video.id ?? " ")
            
            self.videoPlayDetail = res
            PlayURLService.fetchPlayURL(id: video.id){fetched in
                DispatchQueue.main.async {
                    self.videoPlayDetail = fetched
                }
            }
        })
        .padding()
        .navigationTitle(video.title)
    }
}
