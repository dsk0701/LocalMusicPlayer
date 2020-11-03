import UIKit

@IBDesignable
class MiniPlayerView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playOrStopBtn: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        app.player.remove(observer: self)
    }

    private func commonInit() {
        setUpNib()
        app.player.add(observer: self)
    }

    private func setUpNib() {
        let bundle = Bundle(for: type(of: self))
        let view = UINib(nibName: "MiniPlayerView", bundle: bundle).instantiate(withOwner: self, options: nil).first! as! UIView

        view.frame = bounds
        addSubview(view)
    }

    @IBAction func playOrResumeBtnTapped(_ sender: UIButton) {
        app.player.resumeOrPause()
    }
}

extension MiniPlayerView: PlayerObserver {
    func stateDidChanged(state: Player.State) {
        Log.d("state: \(state)")

        var image: UIImage?
        switch state {
        case .stop, .pause, .error:
            image = R.image.play()
        case .playing:
            image = R.image.pause()
        }

        playOrStopBtn.setImage(image, for: UIControlState.normal)
    }
}
