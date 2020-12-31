import MediaPlayer
import AVFoundation
import Combine

protocol PlayerObserver: class {
    func stateDidChanged(state: Player.State)
}

final class Player: NSObject, ObservableObject {
    enum State {
        case stop, playing, pause, error
    }

    @Published private(set) var state = State.stop {
        didSet {
            observers.forEach { $0.stateDidChanged(state: state) }
        }
    }
    @Published private(set) var title: String?
    @Published private(set) var artist: String?
    @Published private(set) var artworkImage: UIImage?

    // NOTE: アルバムのリストなどのデータ表現
    // private(set) var albums: [MPMediaItemCollection]

    private var player = AVQueuePlayer()
    private var observers = [PlayerObserver]()
    private var mediaItems = [MPMediaItem]()
    private var playingItemIndex: Int? {
        didSet {
            guard let playingItemIndex = playingItemIndex, playingItemIndex < mediaItems.count else { return }
            let playingItem = mediaItems[playingItemIndex]
            setNowPlayingInfo(by: playingItem)
            title = playingItem.title
            artist = playingItem.artist
            artworkImage = playingItem.artwork.map { $0.image(at: $0.bounds.size) } ?? nil
        }
    }

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
        mediaItems = items
        playingItemIndex = startIndex
        let playerItems = items
            .compactMap { $0.assetURL }
            .map { AVPlayerItem(url: $0) }
        player = AVQueuePlayer(items: playerItems.dropFirst(startIndex).map { $0 })
        player.play()
        state = .playing
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlayingItem), name: .AVPlayerItemDidPlayToEndTime, object: nil)
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

    @objc func didFinishPlayingItem() {
        // addObserverしたスレッドと別スレッドで実行されるかもしれないのでメインスレッドに切り替える.
        DispatchQueue.main.async { [weak self] in
            guard let prevIndex = self?.playingItemIndex else { return }
            self?.playingItemIndex = prevIndex + 1
        }
    }
}
