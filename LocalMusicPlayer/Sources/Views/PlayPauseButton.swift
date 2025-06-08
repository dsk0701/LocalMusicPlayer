import SwiftUI

struct ResumePauseButton: View {
    let color: Color
    let playerState: Player.State
    let playAction: () -> Void
    let pauseAction: () -> Void

    init(
        color: Color = .white,
        playerState: Player.State,
        playAction: @escaping () -> Void,
        pauseAction: @escaping () -> Void
    ) {
        self.color = color
        self.playerState = playerState
        self.playAction = playAction
        self.pauseAction = pauseAction
    }

    var body: some View {
        switch playerState {
        case .playing:
            PlayerButton(systemName: "pause.fill", color: color, action: {
                _ = pauseAction()
            })
        default:
            PlayerButton(systemName: "play.fill", color: color, action: {
                _ = playAction()
            })
        }
    }
}

struct BackwardButton: View {
    let action: () -> Void

    var body: some View {
        PlayerButton(systemName: "backward.end.alt.fill", action: action)
    }
}

struct ForwardButton: View {
    let action: () -> Void

    var body: some View {
        PlayerButton(systemName: "forward.end.alt.fill", action: action)
    }
}
