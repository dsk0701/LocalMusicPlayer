import UIKit
import MediaPlayer

struct AlbumViewModel: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String?
    let artist: String?
    let artWorkImage: UIImage?
    let mpMediaItem: MPMediaItem

    init(mpMediaItem: MPMediaItem) {
        id = mpMediaItem.persistentID
        title = mpMediaItem.albumTitle
        artist = mpMediaItem.artist
        if let artwork = mpMediaItem.artwork {
            artWorkImage = artwork.image(at: artwork.bounds.size)
        } else {
            artWorkImage = nil
        }
        self.mpMediaItem = mpMediaItem
    }
}
