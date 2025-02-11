import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var player: Player
    @Binding var playerViewHeight: CGFloat
    let album: AlbumViewModel

    private var playingItemIndex: Int? {
        album.mpMediaItemCollection.items.firstIndex(where: { $0 == player.playingItem})
    }

    var body: some View {
        GeometryReader { geometry in
            // VStack内のViewとViewの間にスペースを開けないようにspacing: 0にしている。
            // https://stackoverflow.com/questions/58018633/swiftui-how-to-remove-margin-between-views-in-vstack
            VStack(spacing: 0) {
                List {
                    album.artworkImage.map { uiImage in
                        HStack {
                            Spacer()
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                            Spacer()
                        }
                    }
                    ForEach(album.mpMediaItemCollection.items.indices, id: \.self) { index in
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
                            .listRowBackground(playingItemIndex == index ? Color.orange.opacity(0.2) : nil)
                    }
                }
                    .navigationTitle(Text(album.title ?? ""))
                Rectangle().fill(Color.clear).frame(height: playerViewHeight)
            }
        }
    }
}
