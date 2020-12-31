import UIKit
import MediaPlayer

struct AlbumViewModel: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String?
    let artist: String?
    let artworkImage: UIImage?
    let mpMediaItemCollection: MPMediaItemCollection

    init(mpMediaItemCollection: MPMediaItemCollection) {
        id = mpMediaItemCollection.persistentID
        title = mpMediaItemCollection.representativeItem?.albumTitle
        artist = mpMediaItemCollection.representativeItem?.albumArtist
        if let artwork = mpMediaItemCollection.representativeItem?.artwork {
            artworkImage = artwork.image(at: artwork.bounds.size)
        } else {
            artworkImage = nil
        }
        self.mpMediaItemCollection = mpMediaItemCollection
    }
}
