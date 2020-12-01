import SwiftUI
import MediaPlayer

struct AlbumListRow: View {
    let album: MPMediaItemCollection

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
            album.representativeItem?.artwork.map {
                $0.image(at: $0.bounds.size).map {
                    Image(uiImage: $0)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
            }
            VStack(alignment: .leading) {
                album.representativeItem?.albumTitle.map {
                    Text($0)
                        .lineLimit(1)
                        .font(.headline)
                }
                album.representativeItem?.albumArtist.map {
                    Text($0)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
        }
    }
}
