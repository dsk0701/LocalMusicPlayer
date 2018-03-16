import UIKit
import MediaPlayer

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var album: MPMediaItemCollection!
    private var player: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = album.representativeItem?.albumTitle
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let miniPlayerView = navCon?.miniPlayerView else { return }

        let bottomInset = miniPlayerView.frame.size.height - view.safeAreaInsets.bottom
        tableView.contentInset.bottom = bottomInset
        tableView.scrollIndicatorInsets.bottom = bottomInset
    }
}

extension AlbumDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = album.items[indexPath.row]

        cell.textLabel?.text = song.title
        let duration = song.playbackDuration
        cell.detailTextLabel?.text = String(
            format: "%.f:%02.f",
            floor(duration / Double(60)),
            round(duration.truncatingRemainder(dividingBy: 60))
        )

        return cell
    }
}

extension AlbumDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        app.player.play(item: album.items[indexPath.row])
    }
}

extension AlbumDetailViewController: AVAudioPlayerDelegate {
}
