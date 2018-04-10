import MediaPlayer
import AVFoundation

protocol PlayerObserver: class {
    func stateDidChanged(state: Player.State)
}

class Player: NSObject {
    enum State {
        case stop, playing, pause
    }

    private(set) var state = State.stop {
        didSet {
            observers.forEach { $0.stateDidChanged(state: state) }
        }
    }

    // NOTE: アルバムのリストなどのデータ表現
    // private(set) var albums: [MPMediaItemCollection]
    private(set) var songs = [MPMediaItem]()

    // var isPlaying: Bool {
    //     return player == nil ? false : player.isPlaying
    // }

    private var player: AVAudioPlayer!
    private var observers = [PlayerObserver]()

    override init() {
        super.init()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Log.e(error)
        }

        guard let song = songs.first, let songURL = song.assetURL else { return }

        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            player.delegate = self
            state = .pause
        } catch {
            Log.e(error)
        }
    }

    func add(observer: PlayerObserver) {
        guard !observers.contains(where: { $0 === observer }) else { return }
        observers.append(observer)
    }

    func remove(observer: PlayerObserver) {
        if let index = observers.index(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func play(item: MPMediaItem) {
        guard let songURL = item.assetURL else { return }

        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            player.delegate = self
            player.play()
            songs.append(item)
            state = .playing
        } catch {
            Log.e(error)
        }
    }

    func resumeOrPause() {
        switch state {
        case .playing:
            pause()
        case .pause:
            resume()
        default:
            break
        }
    }

    func resume() {
        guard player != nil else { return }

        player.play()
        state = .playing
    }

    func pause() {
        player.pause()
        state = .pause
    }

    func stop() {
        player.stop()
        state = .stop
    }

    func add(item: MPMediaItem) {
        songs.append(item)
    }
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // 曲の再生が終わったら呼ばれる。
        // TODO: 次の曲を再生する
        Log.d()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        Log.d()
    }

    // 電話がかかってきたときやイヤホンジャックが抜かれたときなどの中断で呼ばれる
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        Log.d()
    }

    // 中断が終わったら呼ばれる
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        Log.d()
    }
}
