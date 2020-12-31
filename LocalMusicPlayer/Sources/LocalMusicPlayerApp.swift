import SwiftUI
import MediaPlayer

@main
struct LocalMusicPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var playerViewHeight = CGFloat.zero

    var body: some Scene {
        WindowGroup {
            ZStack {
                AlbumListView(albums: makeAlbumViewModels())
                    .padding(.bottom, playerViewHeight)
                    .environmentObject(Player())
                VStack {
                    Spacer()
                    PlayerView()
                        .background(Blur().edgesIgnoringSafeArea(.bottom))
                        .frame(maxWidth: .infinity, maxHeight: 60)
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