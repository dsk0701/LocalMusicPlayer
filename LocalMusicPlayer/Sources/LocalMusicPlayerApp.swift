import MediaPlayer
import SwiftUI

@main
struct LocalMusicPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var musicLibraryService = MusicLibraryService()
    @State private var playerViewHeight = CGFloat.zero
    @State private var playerIsPresent = false
    let player = Player()

    var body: some Scene {
        WindowGroup {
            Group {
                if musicLibraryService.authorizationStatus == .authorized {
                    ZStack {
                        AlbumListView(playerViewHeight: $playerViewHeight, albums: musicLibraryService.albums)
                        VStack {
                            Spacer()
                            PlayerView()
                                .frame(maxWidth: .infinity, maxHeight: 60)
                                .fullScreenCover(isPresented: $playerIsPresent) {
                                    FullScreenPlayerView()
                                }
                                .onTapGesture {
                                    playerIsPresent.toggle()
                                }
                        }
                    }
                    .onPreferenceChange(PlayerViewPreferenceKey.self) { value in
                        playerViewHeight = value.size.height
                    }
                    .onAppear {
                        musicLibraryService.loadAlbums()
                    }
                } else {
                    MusicPermissionView(musicLibraryService: musicLibraryService)
                }
            }
            .environmentObject(player)
        }
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
