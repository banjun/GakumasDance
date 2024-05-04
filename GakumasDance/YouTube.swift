import SwiftUI
import UIKit
import WebKit

struct YouTube: UIViewRepresentable {
    let url: URL
    var playbackRate: Float = 1
    var dateSeekToZeroRequested: Date?

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: WKWebView, context: Context) -> CGSize? {
        CGSize(width: 375, height: 734)
    }

    func makeUIView(context: Context) -> WKWebView {
        let c = WKWebViewConfiguration()
        c.allowsAirPlayForMediaPlayback = true
        c.mediaTypesRequiringUserActionForPlayback = []
        let v = WKWebView(frame: .zero, configuration: c)
        v.navigationDelegate = context.coordinator
        v.load(URLRequest(url: url))
        context.coordinator.webView =  v
        return v
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.webView = uiView
        uiView.setPlaybackRate(playbackRate)
        context.coordinator.dateSeekToZeroRequested = dateSeekToZeroRequested
    }

    func makeCoordinator() -> Coordinator { .init() }
    class Coordinator: NSObject, WKNavigationDelegate {
        var webView: WKWebView?
        var dateSeekToZeroRequested: Date? = nil {
            didSet {
                webView?.seekToZero()
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView = webView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                webView.setUnmuted()
            }
        }
    }
}

extension WKWebView {
    func setPlaybackRate(_ playbackRate: Float) {
        evaluateJavaScript("document.getElementsByTagName('video')[0].playbackRate = \(playbackRate)")
    }
    func seekToZero() {
        evaluateJavaScript("document.getElementsByTagName('video')[0].currentTime = 0")
    }
    func setUnmuted() {
        evaluateJavaScript("document.getElementsByTagName('video')[0].muted = false")
    }
}

// how to pause Xcode Preview audio???
//#Preview {
//    YouTube(url: URL(string: "https://www.youtube.com/shorts/jC07Q2Y6uBs")!)
//}
