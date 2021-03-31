import SwiftUI

struct SliderBar: View {
    @EnvironmentObject var player: Player
    @State private var seekPosition: Double = 0.0
    @State private var editing = false

    var body: some View {
        VStack {
            Slider(value: $seekPosition, in: 0...1) { editing in
                self.editing = editing
                // Sliderのボタンを離したときにeditingがfalseになる。
                // 離したタイミングでにseekする。
                if !editing {
                    player.seek(to: seekPosition)
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