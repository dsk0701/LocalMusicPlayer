import UIKit

class TopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let menus = [
        "アルバム",
        "トラック",
        "アーティスト",
        "プレイリスト",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
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
