import SwiftUI

struct AlbumListRow: View {
    let title: String?
    let artist: String?
    let artworkImage: UIImage?

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
            artworkImage.map {
                Image(uiImage: $0)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading) {
                title.map {
                    Text($0)
                        .lineLimit(1)
                        .font(.headline)
                }
                artist.map {
                    Text($0)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

struct AlbumListRow_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListRow(
            title: "アルバムタイトル",
            artist: "アルバムアーティスト",
            artworkImage: UIImage(named: "AlbumImage")
        )
    }
}
