import SwiftUI

struct FullScreenPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var player: Player
    private let dissmissThreshold: CGFloat = 100.0

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            seekBar
                .padding()
                .accentColor(.orange)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .offset(x: 0, y: dragOffset.height)
        .animation(.easeOut)
        .gesture(
            DragGesture()
                // dragOffsetはドラッグ終了で0,0に戻る
                .updating($dragOffset, body: { (value, state, transaction) in
                    guard value.translation.height > 0 else { return }
                    state = value.translation
                })
                .onEnded { (value) in
                    if value.translation.height > dissmissThreshold {
                        presentationMode.wrappedValue.dismiss()
                    }
                    print("value.translation.height: \(value.translation.height)")
                }
        )
    }

    @State private var seekPosition: Double = 0.0
    @State private var editing = false
    private var seekBar: some View {
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

struct FullScreenPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenPlayerView()
    }
}
