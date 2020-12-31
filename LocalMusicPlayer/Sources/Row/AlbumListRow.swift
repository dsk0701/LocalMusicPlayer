import SwiftUI

struct AlbumListRow: View {
    let album: AlbumViewModel

    var body: some View {
        HStack {
            /*
            if let artwork = album.representativeItem?.artwork, let image = artwork.image(at: artwork.bounds.size) {
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            */
            album.artworkImage.map {
                Image(uiImage: $0)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading) {
                album.title.map {
                    Text($0)
                        .lineLimit(1)
                        .font(.headline)
                }
                album.artist.map {
                    Text($0)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
        }
    }
}
