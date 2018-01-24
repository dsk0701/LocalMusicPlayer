import UIKit

class NavigationController: UINavigationController {

    lazy var miniPlayerView: UIButton = {
        let view = UIButton()
        view.backgroundColor = .purple
        view.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
        return view
    }()

    @objc func btnDidTap() {
        print("btnDidTap")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(miniPlayerView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        miniPlayerView.frame = CGRect(
            x: view.frame.origin.x,
            y: view.frame.size.height - 50,
            width: view.frame.size.width,
            height: 50
        )
    }
}
