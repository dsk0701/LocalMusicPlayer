import SwiftUI

struct PlayerView: View {
    var body: some View {
        HStack {
            Image("AlbumImage")
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                Text("曲名")
                Text("アーティスト名")
                    .font(.caption)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                print("TODO: 未実装")
            }, label: {
                // TODO: 状態ごとに画像を変える.
                Image("Play")
            })
        }
        .padding(.all, 8)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerView()
        }.previewLayout(.fixed(width: 320, height: 70))
    }
}
