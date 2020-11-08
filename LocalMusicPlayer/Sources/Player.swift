import MediaPlayer
import AVFoundation

protocol PlayerObserver: class {
    func stateDidChanged(state: Player.State)
}

class Player: NSObject {
    enum State {
        case stop, playing, pause, error
    }

    private(set) var state = State.stop {
        didSet {
            observers.forEach { $0.stateDidChanged(state: state) }
        }
    }

    // NOTE: アルバムのリストなどのデータ表現
    // private(set) var albums: [MPMediaItemCollection]

    // var isPlaying: Bool {
    //     return player == nil ? false : player.isPlaying
    // }

    private var player = AVQueuePlayer()
    private var observers = [PlayerObserver]()

    override init() {
        super.init()

        initRemoteCommand()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Log.e(error)
        }
    }

    func add(observer: PlayerObserver) {
        guard !observers.contains(where: { $0 === observer }) else { return }
        observers.append(observer)
    }

    func remove(observer: PlayerObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func play(items: [MPMediaItem], startIndex: Int) {
        let playerItems = items
            .compactMap { $0.assetURL }
            .map { AVPlayerItem(url: $0) }
        player = AVQueuePlayer(items: playerItems.dropFirst(startIndex).map { $0 })
        player.play()
        state = .playing

        if let item = items.first {
            setNowPlayingInfo(by: item)
        }
    }

    @objc func resumeOrPause() -> MPRemoteCommandHandlerStatus {
        switch state {
        case .playing:
            return pause()
        case .pause:
            return resume()
        default:
            return .commandFailed
        }
    }

    @objc func resume() -> MPRemoteCommandHandlerStatus {
        player.play()
        state = .playing
        return .success
    }

    @objc func pause() -> MPRemoteCommandHandlerStatus {
        player.pause()
        state = .pause
        return .success
    }

    @objc func stop() -> MPRemoteCommandHandlerStatus {
        player.removeAllItems()
        state = .stop
        return .success
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

    private func initRemoteCommand() {
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

    private func setNowPlayingInfo(by item: MPMediaItem) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = item.title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = item.albumTitle
        nowPlayingInfo[MPMediaItemPropertyArtwork] = item.artwork
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = item.playbackDuration
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
