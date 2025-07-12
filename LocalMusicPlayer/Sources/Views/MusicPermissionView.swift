import MediaPlayer
import SwiftUI

struct MusicPermissionView: View {
    @ObservedObject var musicLibraryService: MusicLibraryService

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "music.note")
                .font(.system(size: 80))
                .foregroundColor(.orange)

            VStack(spacing: 16) {
                Text("MusicPermission.Title")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("MusicPermission.Description")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
            }

            Spacer()

            if musicLibraryService.authorizationStatus != .denied {
                Button(action: {
                    musicLibraryService.requestPermission()
                }) {
                    if musicLibraryService.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("MusicPermission.Loading")
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("MusicPermission.AllowAccess")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.orange)
                .cornerRadius(12)
                .disabled(musicLibraryService.isLoading)
                .padding(.horizontal, 32)
            }

            if musicLibraryService.authorizationStatus == .denied {
                VStack(spacing: 12) {
                    Text("MusicPermission.AccessDenied")
                        .font(.subheadline)
                        .foregroundColor(.red)

                    Text("MusicPermission.SettingsHelp")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("MusicPermission.OpenSettings") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    .foregroundColor(.orange)
                    .font(.subheadline)
                }
                .padding(.top, 16)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview("未決定状態") {
    MusicPermissionView(musicLibraryService: MusicLibraryService())
}

#Preview("読み込み中") {
    MusicPermissionView(musicLibraryService: MusicLibraryService(isLoading: true))
}

#Preview("拒否状態") {
    MusicPermissionView(musicLibraryService: MusicLibraryService(authorizationStatus: .denied))
}
