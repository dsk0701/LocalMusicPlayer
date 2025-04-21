import SwiftUI

struct PlayerControlBar: View {
    @ObservedObject var player: Player

    var body: some View {
        HStack {
            // 巻き戻し（.infinityで均等配置）
            PlayerButton(systemName: "backward.end.alt.fill") {
                _ = {}
            }
            .frame(maxWidth: .infinity)

            // 再生・一時停止（.infinityで均等配置）
            let playOrPauseButton = switch player.state {
            case .playing:
                PlayerButton(systemName: "pause.fill") {
                    _ = player.pause()
                }
            default:
                PlayerButton(systemName: "play.fill") {
                    _ = player.resume()
                }
            }
            playOrPauseButton.frame(maxWidth: .infinity)

            // 早送り（.infinityで均等配置）
            PlayerButton(systemName: "forward.end.alt.fill") {
                _ = {}
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct PlayerButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: systemName)
                .font(.largeTitle)
                .foregroundColor(.white)
        })
    }
}

#Preview {
    PlayerControlBar(
        player: Player(
            title: "タイトル",
            artist: "アーティスト",
            artworkImage: UIImage(named: "AlbumImage"),
            currentTimeText: "0:00",
            playbackDurationText: "5:21",
            currentPosition: 0.4
        )
    )
    .frame(maxWidth: .infinity, maxHeight: 60)
    .background(Color.gray)
}
