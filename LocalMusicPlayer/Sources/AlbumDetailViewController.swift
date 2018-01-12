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
        guard let songURL = album.items[indexPath.row].assetURL else { return }

        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            player.delegate = self
            player.play()
        } catch {
            print(error)
        }
    }
}

extension AlbumDetailViewController: AVAudioPlayerDelegate {
}
