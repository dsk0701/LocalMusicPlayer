import UIKit
import MediaPlayer

struct AlbumViewModel: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String?
    let artist: String?
    let artWorkImage: UIImage?
    let mpMediaItemCollection: MPMediaItemCollection

    init(mpMediaItemCollection: MPMediaItemCollection) {
        id = mpMediaItemCollection.persistentID
        title = mpMediaItemCollection.representativeItem?.albumTitle
        artist = mpMediaItemCollection.representativeItem?.albumArtist
        if let artwork = mpMediaItemCollection.representativeItem?.artwork {
            artWorkImage = artwork.image(at: artwork.bounds.size)
        } else {
            artWorkImage = nil
        }
        self.mpMediaItemCollection = mpMediaItemCollection
    }
}
