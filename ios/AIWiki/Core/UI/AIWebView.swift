import SwiftUI
import WebKit

struct AIWebView: UIViewRepresentable {
    let url: URL
    @Binding var reloadTrigger: Bool
    var onPageLoaded: (() -> Void)? = nil
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AIWebView
        
        init(_ parent: AIWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onPageLoaded?()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if reloadTrigger {
            uiView.reload()
            DispatchQueue.main.async {
                reloadTrigger = false
            }
        }
    }
    
    // Static helper for prompt injection
    static func injectPrompt(_ prompt: String, into webView: WKWebView) {
        let escapedPrompt = prompt.replacingOccurrences(of: "\\", with: "\\\\")
                                 .replacingOccurrences(of: "\"", with: "\\\"")
                                 .replacingOccurrences(of: "\n", with: "\\n")
        
        // Comprehensive script to find common AI chat input areas
        let script = """
        (function() {
            const inputs = [
                document.querySelector('textarea'),
                document.querySelector('div[contenteditable="true"]'),
                document.querySelector('input[type="text"]')
            ];
            const input = inputs.find(i => i !== null);
            if (input) {
                if (input.tagName === 'DIV') {
                    input.innerText = "\(escapedPrompt)";
                } else {
                    input.value = "\(escapedPrompt)";
                }
                // Trigger input events for frameworks (React/Vue)
                input.dispatchEvent(new Event('input', { bubbles: true }));
                input.focus();
            }
        })();
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}
