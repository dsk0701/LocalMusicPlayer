import SwiftUI

@main
struct LocalMusicPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @Environment(\.player) private var player

    var body: some Scene {
        WindowGroup {
            AlbumListView()
        }
    }
}

struct PlayerKey: EnvironmentKey {
    // デフォルト値
    static let defaultValue: Player = Player()
}

extension EnvironmentValues {
    var player: Player { self[PlayerKey.self] }
}
