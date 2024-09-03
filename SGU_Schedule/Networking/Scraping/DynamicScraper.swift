//
//  DynamicScraper.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.08.2024.
//

import Foundation
import WebKit

class Delegate: NSObject, WKNavigationDelegate {
    // Факультеты в конце не успевают прогрузиться за две секунды, xddd
    var needToWaitLonger: Bool = false
    var onHTMLExtracted: ((String?) -> ())?
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (needToWaitLonger ? 4.0 : 2.0)) {
            let javascriptToExtractContent = "document.documentElement.outerHTML.toString()"

            webView.evaluateJavaScript(javascriptToExtractContent) { (result, error) in
                self.onHTMLExtracted?(result as? String)
            }
        }
    }
    
//    deinit {
//        print("deinited delegate")
//    }
}

class DynamicScraper: Scraper {
    var delegate = Delegate()
    var webView = WKWebView(frame: CGRect.zero)
    
    func scrapeUrl(_ url: URL, needToWaitLonger: Bool = false, completionHandler: @escaping (String?) -> ()) throws {
        self.delegate.onHTMLExtracted = completionHandler
        self.delegate.needToWaitLonger = needToWaitLonger
        
        self.webView.navigationDelegate = self.delegate
        self.webView.load(URLRequest(url: url))
    }
    
//    deinit {
//        print("deinited scraper")
//    }
}
