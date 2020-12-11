import SwiftUI

struct AlbumDetailView: View {
    let album: AlbumViewModel

    var body: some View {
        List {
            ForEach(album.mpMediaItemCollection.items, id: \.self) { (item) in
                AlbumDetailRow(title: item.title, duration: item.playbackDuration)
            }
        }.navigationTitle(Text(album.title ?? ""))
    }
}
