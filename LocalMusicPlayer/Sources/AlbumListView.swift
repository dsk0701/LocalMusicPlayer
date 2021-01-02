import SwiftUI

struct AlbumListView: View {
    @Binding var playerViewHeight: CGFloat
    let albums: [AlbumViewModel]

    var body: some View {
        NavigationView {
            ScrollView {
                // 表示されているものだけ読み込むためにLazyStack.
                LazyVStack(alignment: .leading) {
                    ForEach(albums) { (album) in
                        NavigationLink(destination: AlbumDetailView(album: album)) {
                            AlbumListRow(album: album)
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
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView(playerViewHeight: .constant(60), albums: [])
    }
}
