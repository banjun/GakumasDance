import SwiftUI

@main
struct GakumasDanceApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        // NOTE: for our physical safety,
        // use .mixed immersion style carefully.
        // the initial immersion style configuration is at:
        // Info.plist/UIApplicationSceneManifest/UISceneConfigurations/UISceneSessionRoleImmersiveSpaceApplication/UISceneInitialImmersionStyle
        ImmersiveSpace(id: "DanceLessonSpace") {
            DanceLessonRoom()
        }
        // prevent background state
        .onChange(of: scenePhase) { _, new in
            if new == .background { exit(0) }
        }
    }
}
