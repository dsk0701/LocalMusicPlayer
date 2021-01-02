import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var player: Player

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    player.artworkImage.map {
                        Image(uiImage: $0)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                    }
                    VStack(alignment: .leading) {
                        player.title.map {
                            Text($0)
                                .lineLimit(1)
                                .font(.headline)
                        }
                        player.artist.map {
                            Text($0)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        _ = player.resumeOrPause()
                    }, label: {
                        switch player.state {
                        case .playing:
                            Image("Pause")
                        default:
                            Image("Play")
                        }
                    })
                }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                Spacer() // bottomセーフエリア用
            }
                .background(Blur().edgesIgnoringSafeArea(.bottom))
                .preference(
                    key: PlayerViewPreferenceKey.self,
                    value: PlayerViewPreference(size: geo.size)
                )
                /*
                // 参考：https://medium.com/eureka-engineering/swiftui%E3%82%92%E5%88%A9%E7%94%A8%E3%81%97%E3%81%9F%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%B8%E3%83%83%E3%82%AF%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AEui%E5%86%8D%E7%8F%BE-e525a63eece7
                // backgroundにGeometryReaderを設定するやり方もある。
                // なぜColor.clearからpreference()呼んでるのはわかっていません。
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(
                                key: PlayerViewPreferenceKey.self,
                                value: PlayerViewPreference(size: proxy.size)
                            )
                    }
                )
                */
        }
    }
}

struct PlayerViewPreference: Equatable {
    let size: CGSize
}

struct PlayerViewPreferenceKey: PreferenceKey {
    typealias Value = PlayerViewPreference

    static var defaultValue: PlayerViewPreference = PlayerViewPreference(size: .zero)

    static func reduce(value: inout Value, nextValue: () -> Value) {
        // 参考：https://fivestars.blog/swiftui/preferencekey-reduce.html
        // .preference()を呼び出している子View分呼ばれる。
        // 子Viewの合計を返したければ以下のように実装する。
        // value += nextValue()
        // ValueがArrayのときは value.append(contentsOf: nextValue())
        // 今回はPlayerViewは1つしかないのと複数の合計を返しても使えないため以下の実装にしている。
        value = nextValue()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerView()
        }.previewLayout(.fixed(width: 320, height: 70))
    }
}
