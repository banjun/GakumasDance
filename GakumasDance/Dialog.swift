import SwiftUI

private let ことねyellow = Color(red: 0.98, green: 0.87, blue: 0.32)

struct Dialog: View {
    @State private var dialogFadeout: Double = 0
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Button("ことねを呼ぶ") {
                withAnimation { dialogFadeout = 1 }
                Task {
                    try! await Task.sleep(for: .seconds(1))
                    action?()
                }
            }
            .buttonStyle(ButtonStyle(keyColor: ことねyellow))
            .scaleEffect(x: 1 + dialogFadeout * 0.2, y: 1 + dialogFadeout * 0.2)
            .animation(.spring, value: dialogFadeout)

            Spacer().frame(width: 100)

            Button("呼ばない") {
            }
            .buttonStyle(ButtonStyle(keyColor: .gray))
            .offset(y: dialogFadeout * 50)
            .animation(.spring, value: dialogFadeout)
        }
        .padding(100)
        .opacity(1 - dialogFadeout)
        .animation(.spring, value: dialogFadeout)
    }

    struct ButtonStyle: SwiftUI.ButtonStyle {
        var keyColor: Color
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .typesettingLanguage(.explicit(.init(identifier: "ja")))
                .font(.largeTitle)
                .foregroundStyle(.black.opacity(0.8))
                .frame(width: 300, height: 200)
                .contentShape(.interaction, .rect(cornerRadius: 20))
                .background(LinearGradient(colors: [.white.opacity(0.8), .white.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                .padding(6)
                .background(keyColor, in: .rect(cornerRadius: 20))
                .hoverEffect()
        }
    }
}

#Preview {
    Dialog()
}
