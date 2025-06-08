import SwiftUI

struct PlayerButton: View {
    let systemName: String
    let color: Color
    let action: () -> Void

    init(
        systemName: String,
        color: Color = .white,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            Image(systemName: systemName)
                .font(.largeTitle)
                .foregroundColor(color)
                .padding()
        })
        // .background(Color.red)
    }
}
