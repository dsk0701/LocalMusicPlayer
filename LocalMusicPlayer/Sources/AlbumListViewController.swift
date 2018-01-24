import UIKit
import MediaPlayer

class AlbumListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let albums: [MPMediaItemCollection] = {
        guard let albums = MPMediaQuery.albums().collections else { return [MPMediaItemCollection]() }
        return albums
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let miniPlayerView = navCon?.miniPlayerView else { return }

        let bottomInset = miniPlayerView.frame.size.height - view.safeAreaInsets.bottom
        tableView.contentInset.bottom = bottomInset
        tableView.scrollIndicatorInsets.bottom = bottomInset
    }
}

extension AlbumListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = album.representativeItem?.albumTitle
        cell.detailTextLabel?.text = album.representativeItem?.albumArtist
        if let artwork = album.representativeItem?.artwork {
            cell.imageView?.image = artwork.image(at: artwork.bounds.size)
        } else {
            cell.imageView?.image = nil
        }
        return cell
    }
}

extension AlbumListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = UIStoryboard(name: "AlbumDetail", bundle: nil).instantiateViewController(withIdentifier: "AlbumDetailViewController") as! AlbumDetailViewController
        vc.album = albums[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
