import MediaPlayer
import SwiftUI

@MainActor
class MusicLibraryService: ObservableObject {
    @Published var authorizationStatus: MPMediaLibraryAuthorizationStatus = .notDetermined
    @Published var albums: [AlbumViewModel] = []
    @Published var isLoading = false

    init(authorizationStatus: MPMediaLibraryAuthorizationStatus = .notDetermined, isLoading: Bool = false) {
        self.authorizationStatus = authorizationStatus
        self.isLoading = isLoading
        if authorizationStatus == .notDetermined {
            checkAuthorizationStatus()
        }
    }

    private func checkAuthorizationStatus() {
        authorizationStatus = MPMediaLibrary.authorizationStatus()
    }

    func requestPermission() {
        isLoading = true
        MPMediaLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
                self?.isLoading = false
                if status == .authorized {
                    self?.loadAlbums()
                }
            }
        }
    }

    func loadAlbums() {
        guard authorizationStatus == .authorized else { return }

        guard let collections = MPMediaQuery.albums().collections else {
            albums = []
            return
        }

        albums = collections.map { AlbumViewModel(mpMediaItemCollection: $0) }
    }
}
