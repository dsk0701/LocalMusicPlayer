import SwiftUI

struct SliderBar: View {
    @ObservedObject var player: Player
    @State private var seekPosition: Double = 0
    @State private var editing = false
    @State private var currentTime: String = ""
    @State private var playbackDuration: String = ""

    init(
        player: Player
    ) {
        self.player = player
    }

    var body: some View {
        VStack {
            Slider(value: $seekPosition, in: 0 ... 1) { editing in
                self.editing = editing
                // Sliderのボタンを離したときにeditingがfalseになる。
                // 離したタイミングでseekする。
                if !editing {
                    player.seek(to: seekPosition)
                }
            }
            .accentColor(.orange)
            HStack {
                Text(currentTime)
                    .foregroundColor(Color.white)
                    .onReceive(player.$currentTimeText) {
                        currentTime = $0
                    }
                Spacer()
                Text(playbackDuration)
                    .foregroundColor(Color.white)
                    .onReceive(player.$playbackDurationText) {
                        playbackDuration = $0
                    }
            }
        }
        .onReceive(player.$currentPosition) {
            // Sliderのボタンをいじっているときは位置を変更しない。
            guard !editing else { return }
            seekPosition = $0
        }
    }
}

#Preview {
    SliderBar(
        player: Player(
            title: "タイトル",
            artist: "アーティスト",
            artworkImage: UIImage(named: "AlbumImage"),
            currentTimeText: "0:00",
            playbackDurationText: "5:21",
            currentPosition: 0.4
        )
    )
    .background(Color.black)
}
