import UIKit

class NavigationController: UINavigationController {

    let miniPlayerHeight = CGFloat(60)

    lazy var miniPlayerView: MiniPlayerView = {
        let view = MiniPlayerView()
        // TODO: Add Action.
        // view.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
        return view
    }()

    @objc func btnDidTap() {
        Log.d("btnDidTap")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(miniPlayerView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        miniPlayerView.frame = CGRect(
            x: view.frame.origin.x,
            y: view.frame.size.height - miniPlayerHeight,
            width: view.frame.size.width,
            height: miniPlayerHeight
        )
    }
}
