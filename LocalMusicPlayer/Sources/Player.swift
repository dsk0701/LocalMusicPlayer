import MediaPlayer

class Player: NSObject {
    // NOTE: アルバムのリストなどのデータ表現
    // private(set) var albums: [MPMediaItemCollection]

    private(set) var songs = [MPMediaItem]()

    private var player: AVAudioPlayer!

    func play(item: MPMediaItem) {
        guard let songURL = item.assetURL else { return }

        do {
            player = try AVAudioPlayer(contentsOf: songURL)
            player.delegate = self
            player.play()
        } catch {
            print(error)
        }
    }

    func add(item: MPMediaItem) {
        songs.append(item)
    }
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    }

    // 電話がかかってきたときやイヤホンジャックが抜かれたときなどの中断で呼ばれる
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    }

    // 中断が終わったら呼ばれる
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
    }
}
