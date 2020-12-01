import SwiftUI
import MediaPlayer

struct AlbumListView: View {
    private let albums: [MPMediaItemCollection] = {
        guard let albums = MPMediaQuery.albums().collections else { return [MPMediaItemCollection]() }
        return albums
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(albums, id: \.self) { (album) in
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        AlbumListRow(album: album)
                    }
                }
            }.navigationTitle(Text("アルバム"))
        }
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView()
    }
}
