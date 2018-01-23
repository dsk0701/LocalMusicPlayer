import UIKit

class TopViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    lazy var playerView: UIButton = {
        let view = UIButton()
        view.backgroundColor = .purple
        view.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
        return view
    }()

    @objc func btnDidTap() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.footerView.isHidden = !self.footerView.isHidden
        })
    }

    /*
    private let menus = [
        R.string.localizable.topMenuAlbum(),
        R.string.localizable.topMenuTrack(),
        R.string.localizable.topMenuArtist(),
        R.string.localizable.topMenuPlaylist(),
    ]
    */

    private let menus = (0..<100).map { String($0) }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(playerView)
        // stackView.addArrangedSubview(playerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let size = min(view.frame.width, view.frame.height)/4
        playerView.frame = CGRect(x: view.frame.width - size - 8, y: view.frame.height - size - 8, width: size, height: size)
        playerView.layer.cornerRadius = size/2
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
