//
//  DynamicScraper.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.08.2024.
//

import Foundation
import WebKit

// Чат гпт
// При норм инете работает все еще медленнее ожидания в тупую
// Вроде тоже при медленном инете не робит

// class Delegate: NSObject, WKNavigationDelegate {
//    var onHTMLExtracted: ((String?) -> ())?
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        injectNetworkMonitoringScript(webView)
//    }
//
//    private func injectNetworkMonitoringScript(_ webView: WKWebView) {
//        let monitoringScript = """
//        (function() {
//            var activeRequests = 0;
//
//            function trackRequestsStart() {
//                activeRequests++;
//            }
//
//            function trackRequestsEnd() {
//                activeRequests--;
//                if (activeRequests === 0) {
//                    window.allRequestsComplete = true;
//                }
//            }
//
//            // Monitor fetch API calls
//            var originalFetch = window.fetch;
//            window.fetch = function() {
//                trackRequestsStart();
//                return originalFetch.apply(this, arguments).finally(trackRequestsEnd);
//            };
//
//            // Monitor XMLHttpRequest calls
//            var originalXHR = window.XMLHttpRequest.prototype.send;
//            window.XMLHttpRequest.prototype.send = function() {
//                trackRequestsStart();
//                this.addEventListener('loadend', trackRequestsEnd);
//                return originalXHR.apply(this, arguments);
//            };
//
//            // Initially set to false
//            window.allRequestsComplete = false;
//
//        })();
//        """
//
//        webView.evaluateJavaScript(monitoringScript) { (result, error) in
//            self.waitForNetworkActivityToEnd(webView, timeout: 4.0)
//        }
//    }
//
//    private func waitForNetworkActivityToEnd(_ webView: WKWebView, timeout: Double) {
//        let startTime = DispatchTime.now()
//
//        func pollForCompletion() {
//            let checkRequestsScript = """
//            (function() {
//                return window.allRequestsComplete === true && document.readyState === 'complete';
//            })();
//            """
//
//            webView.evaluateJavaScript(checkRequestsScript) { (result, error) in
//                let elapsedTime = Double(DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
//
//                if let isReady = result as? Bool, isReady {
//                    self.extractHTML(webView)
//                } else if elapsedTime >= timeout {
//                    self.extractHTML(webView)
//                }
//                else {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        pollForCompletion()
//                    }
//                }
//            }
//        }
//        
//        pollForCompletion()
//    }
//
//    private func extractHTML(_ webView: WKWebView) {
//        let javascriptToExtractContent = "document.documentElement.outerHTML.toString()"
//        webView.evaluateJavaScript(javascriptToExtractContent) { (result, error) in
//            self.onHTMLExtracted?(result as? String)
//        }
//    }
// }

// С ожиданием в тупую, с медленным инетом просто может не успеть загрузить
class Delegate: NSObject, WKNavigationDelegate {
    var onHTMLExtracted: ((String?) -> Void)?

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let javascriptToExtractContent = "document.documentElement.outerHTML.toString()"

            webView.evaluateJavaScript(javascriptToExtractContent) { (result, _) in
                self.onHTMLExtracted?(result as? String)
            }
        }
    }
}

class DynamicScraper: Scraper {
    var delegate = Delegate()
    var webView = WKWebView(frame: CGRect.zero)

    func scrapeUrl(_ url: URL, completionHandler: @escaping (String?) -> Void) {
        self.delegate.onHTMLExtracted = completionHandler

        self.webView.navigationDelegate = self.delegate
        self.webView.load(URLRequest(url: url))
    }
}
