import SwiftUI
import MediaPlayer

@main
struct LocalMusicPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @Environment(\.player) private var player

    var body: some Scene {
        WindowGroup {
            ZStack {
                AlbumListView(albums: makeAlbumViewModels())
                VStack {
                    Spacer()
                    PlayerView()
                        .background(Blur().edgesIgnoringSafeArea(.bottom))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                }
            }
        }
    }

    private func makeAlbumViewModels() -> [AlbumViewModel] {
        guard let collections = MPMediaQuery.albums().collections else { return [] }
        return collections.map { AlbumViewModel(mpMediaItemCollection: $0) }
    }
}

struct PlayerKey: EnvironmentKey {
    // デフォルト値
    static let defaultValue: Player = Player()
}

extension EnvironmentValues {
    var player: Player { self[PlayerKey.self] }
}
