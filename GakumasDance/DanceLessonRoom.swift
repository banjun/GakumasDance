import SwiftUI
import RealityKit
import AVKit

// the video file is not in the repo in terms of both its file size and its copyright.
// add euirectangular video converted to be playable in QuickTime.
// for example:
// ffmpeg -i 【学マス】「360度」初星学園ツアー動画（特別教育棟\ ダンスレッスン室）【アイドルマスター】\ \[rr1dfUET5Bs\].mp4 -vcodec hevc_videotoolbox -tag:v hvc1 -vb 2000k -strict unofficial -acodec copy 【学マス】「360度」初星学園ツアー動画（特別教育棟\ ダンスレッスン室）【 アイドルマスター】\ \[rr1dfUET5Bs\].mp4.hevc.mp4
private let 初星学園ツアー動画（特別教育棟_ダンスレッスン室） = Bundle.main.url(forResource: "【学マス】「360度」初星学園ツアー動画（特別教育棟 ダンスレッスン室）【アイドルマスター】 [rr1dfUET5Bs].mp4.hevc", withExtension: "mp4")!
private let positionByVideoTime = CMTime(seconds: 50, preferredTimescale: 600)
private let videoAngle = Angle2D.degrees(-120)
private let 世界一可愛い私_レッスン動画_short = "https://www.youtube.com/shorts/jC07Q2Y6uBs"

struct DanceLessonRoom: View {
    @State private var phase: Phase = .dialog
    enum Phase {
        case dialog, lesson
    }
    @State private var interactionMode: InteractionMode = .none
    @State private var isMirrored: Bool = false
    @State private var playbackRate: Float = 1
    @State private var dateSeekToZeroRequested: Date? = nil
    @State private var scale: Float = 3
    @State private var position: SIMD3<Float> = .init(x: -0.2, y: 1, z: -1)

    var body: some View {
        RealityView { content, attachments in
            let player = AVPlayer(url: 初星学園ツアー動画（特別教育棟_ダンスレッスン室）)
            let videoMaterial = VideoMaterial(avPlayer: player)
            let e = ModelEntity(mesh: .generateSphere(radius: 30), materials: [videoMaterial])
            e.scale.x = -1
            e.transform.rotation = .init(Rotation3D(angle: videoAngle, axis: .y))
            content.add(e)

            let d = attachments.entity(for: "Dialog")!
            d.position = .init(x: 0, y: 1.5, z: -0.5)
            content.add(d)

            let y = attachments.entity(for: "YouTube")!
            y.components[InputTargetComponent.self] = .init()
            content.add(y)

            let c = attachments.entity(for: "ControlPanel")!
            c.position = .init(x: 0.5, y: 0.7, z: -0.5)
            c.transform.rotation = .init(Rotation3D(angle: .degrees(-60), axis: .x))
            content.add(c)
        } update: { content, attachments in
            let y = attachments.entity(for: "YouTube")!
            // collision prevents normal SwiftUI interactions
            y.components[CollisionComponent.self] = interactionMode == .web ? nil : .init(shapes: [.generateBox(width: 0.3, height: 0.5, depth: 0.05)])

            y.position = position
            y.transform.scale = .init(repeating: .init(scale))
        } attachments: {
            Attachment(id: "Dialog") {
                Dialog { phase = .lesson }
            }
            Attachment(id: "YouTube") {
                switch phase {
                case .dialog: EmptyView()
                case .lesson:
                    YouTube(url: URL(string: 世界一可愛い私_レッスン動画_short)!, playbackRate: playbackRate, dateSeekToZeroRequested: dateSeekToZeroRequested)
                        .rotation3DEffect(.degrees(isMirrored ? 180 : 0), axis: .y)
                        .animation(.spring(.bouncy), value: isMirrored)
                }
            }
            Attachment(id: "ControlPanel") {
                ControlPanel(interactionMode: $interactionMode, isMirrored: $isMirrored, playbackRate: $playbackRate, dateSeekToZeroRequested: $dateSeekToZeroRequested, scale: $scale)
                    .opacity(phase == .lesson ? 1 : 0)
            }
        }
        .simultaneousGesture(DragGesture(coordinateSpace: .local).targetedToAnyEntity().onChanged { v in
            guard interactionMode == .drag else { return }
            position = v.convert(v.location3D, from: .local, to: .scene)
        })
    }
}

#Preview(immersionStyle: .mixed) {
    DanceLessonRoom()
}
