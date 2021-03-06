import SwiftUI

struct AlbumDetailRow: View {
    let title: String?
    let artist: String?
    let duration: TimeInterval

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                title.map { Text($0) }
                artist.map { Text($0).font(.caption) }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(format(duration: duration))
                .font(.subheadline)
        }
    }

    private func format(duration: TimeInterval) -> String {
        String(
            format: "%.f:%02.f",
            floor(duration / Double(60)),
            round(duration.truncatingRemainder(dividingBy: 60))
        )
    }
}

struct AlbumDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumDetailRow(
                title: "GOOD LIFE",
                artist: "SUITE CHIC Feat.XBS",
                duration: 12345.678
            )
        }
    }
}
