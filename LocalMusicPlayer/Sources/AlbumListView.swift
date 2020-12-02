import SwiftUI

struct AlbumListView: View {
    let albums: [AlbumViewModel]

    var body: some View {
        NavigationView {
            List {
                ForEach(albums) { (album) in
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
        AlbumListView(albums: [])
    }
}
