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

        initRemoteCommand()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Log.e(error)
        }

        // TODO: 再生中の曲を再生したり
        guard let song = songs.first, let songURL = song.assetURL else { return }

        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            player.delegate = self
            state = .pause
        } catch {
            Log.e(error)
        }
    }

    func initRemoteCommand() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget(self, action: #selector(resume))
        commandCenter.pauseCommand.addTarget(self, action: #selector(pause))
        commandCenter.stopCommand.addTarget(self, action: #selector(stop))
        commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(resumeOrPause))
        // NOTE: リモコンにはひとまずスキップより曲送りを表示
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(nextTrack(event:)))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(previousTrack(event:)))
        // commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: 10)]
        // commandCenter.skipForwardCommand.addTarget(self, action: #selector(skipForward(event:)))
        // commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: 10)]
        // commandCenter.skipBackwardCommand.addTarget(self, action: #selector(skipBackward))
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
            player.prepareToPlay()
            player.play()

            songs.append(item)
            setNowPlayingInfo(by: item)
            state = .playing
        } catch {
            Log.e(error)
        }
    }

    @objc func resumeOrPause() {
        switch state {
        case .playing:
            pause()
        case .pause:
            resume()
        default:
            break
        }
    }

    @objc func resume() {
        guard player != nil else { return }

        player.play()
        state = .playing
    }

    @objc func pause() {
        player.pause()
        state = .pause
    }

    @objc func stop() {
        player.stop()
        state = .stop
    }

    @objc func nextTrack(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        // TODO:
        Log.d(event.command)
        return .success
    }

    @objc func previousTrack(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        // TODO:
        Log.d(event.command)
        return .success
    }

    @objc func skipForward(event: MPSkipIntervalCommandEvent) -> MPRemoteCommandHandlerStatus {
        // TODO:
        Log.d(event.interval)
        return .success
    }

    @objc func skipBackward(event: MPSkipIntervalCommandEvent) -> MPRemoteCommandHandlerStatus {
        // TODO:
        Log.d(event.interval)
        return .success
    }

    func add(item: MPMediaItem) {
        songs.append(item)
    }

    private func setNowPlayingInfo(by item: MPMediaItem) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = item.title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = item.albumTitle
        nowPlayingInfo[MPMediaItemPropertyArtwork] = item.artwork
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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
