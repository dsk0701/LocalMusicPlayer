import SwiftUI

struct PlayerControlBar: View {
    @ObservedObject var player: Player

    var body: some View {
        HStack {
            // 巻き戻し（.infinityで均等配置）
            BackwardButton {
                player.previousTrack()
            }
            .frame(maxWidth: .infinity)

            // 再生・一時停止（.infinityで均等配置）
            ResumePauseButton(
                playerState: player.state,
                playAction: { _ = player.resume() },
                pauseAction: { _ = player.pause() }
            )
            .frame(maxWidth: .infinity)

            // 早送り（.infinityで均等配置）
            ForwardButton {
                player.nextTrack()
            }
            .frame(maxWidth: .infinity)
        }
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
