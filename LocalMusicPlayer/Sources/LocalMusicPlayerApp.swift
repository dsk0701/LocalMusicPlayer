import SwiftUI
import MediaPlayer

@main
struct LocalMusicPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var playerViewHeight = CGFloat.zero
    @State private var playerIsPresent = false
    let player = Player()

    var body: some Scene {
        WindowGroup {
            ZStack {
                AlbumListView(playerViewHeight: $playerViewHeight, albums: makeAlbumViewModels())
                    .environmentObject(player)
                VStack {
                    Spacer()
                    PlayerView()
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .environmentObject(player)
                        .fullScreenCover(isPresented: $playerIsPresent, content: FullScreenPlayerView.init)
                    .onTapGesture {
                        self.playerIsPresent.toggle()
                    }
                }
            }.onPreferenceChange(PlayerViewPreferenceKey.self) { value in
                playerViewHeight = value.size.height
            }
        }
    }

    private func makeAlbumViewModels() -> [AlbumViewModel] {
        guard let collections = MPMediaQuery.albums().collections else { return [] }
        return collections.map { AlbumViewModel(mpMediaItemCollection: $0) }
    }
}

/*
SwiftUIでのシングルトンは、下記のようにする事で実現できる。

struct SomeView: View {
    @Environment(\.player) private var player
}

struct PlayerKey: EnvironmentKey {
    // デフォルト値
    static let defaultValue: Player = Player()
}

extension EnvironmentValues {
    var player: Player { self[PlayerKey.self] }
}
*/
