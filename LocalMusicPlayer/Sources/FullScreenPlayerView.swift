import SwiftUI

struct FullScreenPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    private let dissmissThreshold: CGFloat = 100.0

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
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
                .onEnded({ (value) in
                    if value.translation.height > dissmissThreshold {
                        presentationMode.wrappedValue.dismiss()
                    }
                    print("value.translation.height: \(value.translation.height)")
                })
        )
    }
}

struct FullScreenPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenPlayerView()
    }
}
