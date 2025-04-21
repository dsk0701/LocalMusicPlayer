import SwiftUI

struct FullScreenPlayerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var player: Player

    @State private var eraseOuted = false
    @State private var dragOffsetY: CGFloat = .zero
    private let dissmissThreshold: CGFloat = UIScreen.main.bounds.height / 3

    var body: some View {
        VStack {
            // TODO: レイアウト作成中
            player.title.map {
                Text($0)
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .lineLimit(1)
            }
            player.artist.map {
                Text($0)
                    .foregroundColor(Color.white)
                    .font(.caption)
                    .lineLimit(1)
            }
            player.artworkImage.map {
                Image(uiImage: $0)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
            }
            PlayerControlBar(player: player)
                .frame(maxWidth: .infinity, maxHeight: 30)
            SliderBar(player: player)
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(Color.white)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(BackgroundView(referenceImage: player.artworkImage))
        .cornerRadius(20)
        .ignoresSafeArea(edges: [.bottom])
        .background(TransparentBackgroundView())
        .offset(y: dragOffsetY)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        dragOffsetY = 0
                    } else {
                        dragOffsetY = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > dissmissThreshold {
                        dismiss()
                    } else {
                        withAnimation(.linear(duration: 0.10)) {
                            dragOffsetY = 0
                        }
                    }
                }
        )
    }
}

private struct BackgroundView: View {
    let referenceImage: UIImage?

    // 未使用。実装参考のため残しています。
    var brandColor: Color? {
        guard let uiColor = referenceImage?.getBrandColor() else { return nil }
        return Color(uiColor: uiColor)
    }

    var averageColor: Color? {
        guard let uiColor = referenceImage?.getAverageColor() else { return nil }
        return Color(uiColor: uiColor)
    }

    public var body: some View {
        let fromColor = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
        let toColor = Color(red: 0, green: 0, blue: 0, opacity: 1.0)
        LinearGradient(
            gradient: Gradient(colors: [averageColor ?? fromColor, toColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// 下スワイプで閉じる際、sheetのように背景透過させるための記述
private struct TransparentBackgroundView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let view = UIView()
        Task { @MainActor in
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}

struct FullScreenPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenPlayerView()
            .environmentObject(
                Player(
                    title: "タイトル",
                    artist: "アーティスト",
                    artworkImage: UIImage(named: "AlbumImage")
                )
            )
    }
}
