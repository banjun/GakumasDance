import SwiftUI

enum InteractionMode: String, CaseIterable, Hashable, Identifiable {
    case none, web, drag
    var id: String { rawValue }
}

struct ControlPanel: View {
    var width: CGFloat = 400
    @Binding var interactionMode: InteractionMode
    @Binding var isMirrored: Bool
    @Binding var playbackRate: Float
    @Binding var dateSeekToZeroRequested: Date?
    @Binding var scale: Float
    private let rateFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    var body: some View {
        VStack {
            Picker(selection: $interactionMode) {
                ForEach(InteractionMode.allCases) {
                    Text($0.rawValue).tag($0)
                }
            } label: { Text("Interaction Mode") }
                .pickerStyle(.palette)
                .frame(width: width)
                .padding()

            Toggle(isOn: $isMirrored, label: {
                Text("Mirror")
            })
            .toggleStyle(.button)
            .padding()

            Slider(value: $scale, in: 2...10) { Text("Scale") }.frame(width: width / 2)
                .padding()

            Picker(selection: $playbackRate) {
                ForEach([0.25, 0.5, 0.75, 0.8, 1], id: \.self) {
                    Text(String(rateFormatter.string(from: .init(value: $0))!) + "x").tag(Float($0))
                }
            } label: { Text("Speed") }
                .pickerStyle(.palette)
                .frame(width: 400)
                .padding()

            Button {
                dateSeekToZeroRequested = Date()
            } label: {
                Image(systemName: "backward.end.fill")
            }
            .padding()
        }
        .frame(minWidth: width)
        .padding()
        .glassBackgroundEffect()
    }
}

#Preview {
    struct P: View {
        @State private var interactionMode: InteractionMode = .none
        @State private var isMirrored: Bool = false
        @State private var playbackRate: Float = 1
        @State private var dateSeekToZeroRequested: Date? = nil
        @State private var scale: Float = 3
        var body: some View {
            ControlPanel(interactionMode: $interactionMode, isMirrored: $isMirrored, playbackRate: $playbackRate, dateSeekToZeroRequested: $dateSeekToZeroRequested, scale: $scale)
        }
    }
    return P()
}
