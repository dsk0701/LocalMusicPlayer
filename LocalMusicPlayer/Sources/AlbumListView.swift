import SwiftUI

struct AlbumListView: View {
    @Binding var playerViewHeight: CGFloat
    let albums: [AlbumViewModel]

    var body: some View {
        NavigationView {
            ScrollView {
                // 表示されているものだけ読み込むためにLazyStack.
                LazyVStack(alignment: .leading) {
                    ForEach(albums) { album in
                        // Row内にDividerつけるとタップ時に反応してしまう。
                        // また、Rowの下側につけるとDividerの上下にPaddingついているらしく、下までスクロールすると隙間ができるので上側につけている。
                        Divider()
                        NavigationLink(destination: AlbumDetailView(playerViewHeight: $playerViewHeight, album: album)) {
                            AlbumListRow(
                                title: album.title,
                                artist: album.artist,
                                artworkImage: album.artworkImage
                            )
                        }
                    }
                }
                // contentInsetをつけている。
                // このやり方の記事が多く書かれているが、どうしても少し余分な高さが出てしまうのでRectangleを使うようにした。
                // Color.clear.padding(.bottom, playerViewHeight)
                Rectangle().fill(Color.clear).frame(height: playerViewHeight)
            }
            .navigationTitle(Text("アルバム"))
        }
        .accentColor(Color.orange)
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView(playerViewHeight: .constant(60), albums: [])
    }
}
