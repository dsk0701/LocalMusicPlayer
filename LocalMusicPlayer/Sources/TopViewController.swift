import UIKit

class TopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let menus = [
        R.string.localizable.topMenuAlbum(),
        R.string.localizable.topMenuTrack(),
        R.string.localizable.topMenuArtist(),
        R.string.localizable.topMenuPlaylist(),
    ]

    // private let menus = (0..<100).map { String($0) }

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

extension TopViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
}

extension TopViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = UIStoryboard(name: "AlbumList", bundle: nil).instantiateViewController(withIdentifier: "AlbumListViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
}
