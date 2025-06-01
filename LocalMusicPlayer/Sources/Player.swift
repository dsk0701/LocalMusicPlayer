import AVFoundation
import Combine
import MediaPlayer

final class Player: NSObject, ObservableObject {
    enum State {
        case stop, playing, pause, error
    }

    @Published private(set) var state = State.stop
    @Published private(set) var title: String?
    @Published private(set) var artist: String?
    @Published private(set) var artworkImage: UIImage?
    @Published private(set) var currentTimeText: String = ""
    @Published private(set) var playbackDurationText: String = ""
    @Published private(set) var currentPosition: Double = 0 // 0〜1

    // NOTE: アルバムのリストなどのデータ表現
    // private(set) var albums: [MPMediaItemCollection]

    private var player = AVQueuePlayer()
    private var mediaItems = [MPMediaItem]()
    private var playingItemIndex: Int? {
        didSet {
            guard let playingItemIndex, playingItemIndex < mediaItems.count else { return }
            playingItem = mediaItems[playingItemIndex]
        }
    }

    private(set) var playingItem: MPMediaItem? {
        didSet {
            guard let item = playingItem else { return }
            setNowPlayingInfo(by: item)
        }
    }

    private var timeObserverToken: Any?

    convenience init(
        title: String? = nil,
        artist: String? = nil,
        artworkImage: UIImage? = nil,
        currentTimeText: String = "",
        playbackDurationText: String = "",
        currentPosition: Double = 0
    ) {
        self.init()
        self.title = title
        self.artist = artist
        self.artworkImage = artworkImage
        self.currentTimeText = currentTimeText
        self.playbackDurationText = playbackDurationText
        self.currentPosition = currentPosition
    }

    override private init() {
        super.init()
        initRemoteCommand()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Log.e(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlayingItem), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        removePeriodicTimeObserver()
    }

    func play(items: [MPMediaItem], startIndex: Int) {
        mediaItems = items
        let playerItems = items
            .compactMap(\.assetURL)
            .map { AVPlayerItem(url: $0) }
        removePeriodicTimeObserver()
        player = AVQueuePlayer(items: playerItems.dropFirst(startIndex).map(\.self))
        addPeriodicTimeObserver()
        player.play()
        playingItemIndex = startIndex
        state = .playing
    }

    func seek(to position: Double) {
        guard let duration = player.currentItem?.duration else { return }
        let time = duration.seconds * position
        // seek中はPeriodicTimeObserverを外す。
        // そうしないと通知が止まらず画面のSeek位置が一瞬もとに戻ってしまう。
        removePeriodicTimeObserver()
        player.seek(to: cmTime(seconds: time)) { [weak self] _ in
            self?.addPeriodicTimeObserver()
        }
    }

    func nextTrack() {
        // 再生リストの最後だったら停止する。表示は１曲目。
        guard let currentIndex = playingItemIndex else { return }
        let nextIndex = currentIndex + 1
        if nextIndex < mediaItems.count {
            // 次の曲を再生
            play(items: mediaItems, startIndex: nextIndex)
        } else {
            // TODO: やりたいこととしては、自動で次の再生リストを作成して再生したい。
            reset()
        }
    }

    func reset() {
        // 再生リストの１曲目に戻って pause する。
        play(items: mediaItems, startIndex: 0)
        _ = pause()
    }

    @objc func resumeOrPause() -> MPRemoteCommandHandlerStatus {
        switch state {
        case .playing:
            pause()
        case .pause:
            resume()
        default:
            .commandFailed
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

    @objc func next() -> MPRemoteCommandHandlerStatus {
        .noSuchContent
    }

    @objc func nextTrack(event _: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        nextTrack()
        return .success
    }

    @objc func previousTrack(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        // TODO:
        Log.d(event.command)
        return .success
    }

    @objc func changePlaybackPosition(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        player.seek(to: cmTime(seconds: event.positionTime))
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
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPosition(event:)))
        // NOTE: 10 秒スキップ（進める・戻す)
        // commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: 10)]
        // commandCenter.skipForwardCommand.addTarget(self, action: #selector(skipForward(event:)))
        // commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: 10)]
        // commandCenter.skipBackwardCommand.addTarget(self, action: #selector(skipBackward))
    }

    private func setNowPlayingInfo(by item: MPMediaItem) {
        title = item.title
        artist = item.artist
        artworkImage = item.artwork.map { $0.image(at: $0.bounds.size) } ?? nil
        playbackDurationText = formatTime(cmTime: cmTime(seconds: item.playbackDuration))
        setCurrentTime(currentItemDuration: item.playbackDuration)

        setNowPlayingInfoCenter(by: item)
    }

    private func setNowPlayingInfoCenter(by item: MPMediaItem) {
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
            self?.nextTrack()
        }
    }

    private func addPeriodicTimeObserver() {
        let time = cmTime(seconds: 0.5)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] _ in
            guard let self, let currentItemDuration = playingItem?.playbackDuration else { return }
            setCurrentTime(currentItemDuration: currentItemDuration)
        }
    }

    private func setCurrentTime(currentItemDuration: TimeInterval) {
        currentPosition = player.currentTime().seconds / currentItemDuration
        currentTimeText = formatTime(cmTime: player.currentTime())
    }

    private func removePeriodicTimeObserver() {
        if let timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    private func cmTime(seconds: TimeInterval) -> CMTime {
        // REF: https://stackoverflow.com/questions/51353375/how-to-convert-timeinterval-to-cmtime-in-swift-4
        CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }

    private func formatTime(cmTime: CMTime) -> String {
        guard !cmTime.seconds.isNaN || cmTime.seconds.isZero else { return "0:00" }

        let flooredSeconds = floor(cmTime.seconds)
        let minute = Int(flooredSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let second = Int(flooredSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minute, second)
    }
}
