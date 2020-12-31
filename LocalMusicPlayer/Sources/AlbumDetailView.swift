import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var player: Player
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
                ForEach(album.mpMediaItemCollection.items.indices) { index in
                    Button(action: {
                        player.play(items: album.mpMediaItemCollection.items, startIndex: index)
                    }, label: {
                        let item = album.mpMediaItemCollection.items[index]
                        AlbumDetailRow(
                            title: item.title,
                            artist: item.artist != item.albumArtist ? item.artist : nil, // アルバムのアーティストと曲のアーティストが異なる場合のみ表示する。
                            duration: item.playbackDuration
                        )

                        // @Publishedの動作確認用
                        switch player.state {
                        case .stop:
                            Text("player.stop")
                        case .playing:
                            Text("player.playing")
                        case .pause:
                            Text("player.pause")
                        case .error:
                            Text("player.error")
                        }
                    })
                }
            }.navigationTitle(Text(album.title ?? ""))
        }
    }
}
