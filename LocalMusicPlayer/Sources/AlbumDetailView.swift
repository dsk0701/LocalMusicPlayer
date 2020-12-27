import SwiftUI

struct AlbumDetailView: View {
    let album: AlbumViewModel

    var body: some View {
        GeometryReader { geometry in
            List {
                album.artWorkImage.map { uiImage in
                    HStack {
                        Spacer()
                        Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                        Spacer()
                    }
                }
                ForEach(album.mpMediaItemCollection.items, id: \.self) { (item) in
                    AlbumDetailRow(title: item.title, duration: item.playbackDuration)
                }
            }.navigationTitle(Text(album.title ?? ""))
        }
    }
}
