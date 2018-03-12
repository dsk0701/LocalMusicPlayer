import UIKit

@IBDesignable
class MiniPlayerView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playOrStopBtn: UIButton!

    private var state = State.stop {
        didSet {
            didUpdated(state: state)
        }
    }

    enum State {
        case stop, playing
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let view = UINib(nibName: "MiniPlayerView", bundle: bundle).instantiate(withOwner: self, options: nil).first! as! UIView

        view.frame = bounds
        addSubview(view)
    }

    @IBAction func playOrStopBtnTapped(_ sender: UIButton) {
        switch state {
        case .stop:
            state = .playing
        case .playing:
            state = .stop
        }
    }

    private func didUpdated(state: State) {
        var image: UIImage?
        switch state {
        case .stop:
            image = R.image.play()
        case .playing:
            image = R.image.pause()
        }
        playOrStopBtn.setImage(image, for: UIControlState.normal)
    }
}
