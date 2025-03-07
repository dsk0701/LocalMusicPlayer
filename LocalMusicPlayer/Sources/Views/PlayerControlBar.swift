import SwiftUI

struct SliderBar: View {
    @EnvironmentObject var player: Player
    @State private var seekPosition: Double = 0.0
    @State private var editing = false
    
    @ObservedObject var p: Player
    let onSeeked: (Double) -> Void

    var body: some View {
        VStack {
            Slider(value: $seekPosition, in: 0 ... 1) { editing in
                self.editing = editing
                // Sliderのボタンを離したときにeditingがfalseになる。
                // 離したタイミングでseekする。
                if !editing {
                    onSeeked(seekPosition)
                }
            }
            HStack {
                // TODO: フォントの調整する
                Text("0:45")
                    .foregroundColor(Color.white)
                Spacer()
                Text("11:00")
                    .foregroundColor(Color.white)
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
        p: Player(
            title: "タイトル",
            artist: "アーティスト",
            artworkImage: UIImage(named: "AlbumImage")
        ),onSeeked: {_ in }
    )
    .background(Color.black)
    .environmentObject(
        Player(
            title: "タイトル",
            artist: "アーティスト",
            artworkImage: UIImage(named: "AlbumImage")
        )
    )
}
