import SwiftUI

struct AlbumDetailRow: View {
    let title: String?
    let duration: TimeInterval

    var body: some View {
        HStack {
            title.map {
                Text($0)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text(format(duration: duration))
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
            AlbumDetailRow(title: "恋のマシンガン", duration: 12345.678)
        }
    }
}
