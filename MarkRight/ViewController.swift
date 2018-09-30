//
//  ViewController.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa
import WebKit
import FP

private let theme: String = {
    
    let path = Bundle.main.path(forResource: "theme", ofType: "css")!
    return try! String(contentsOfFile: path)
}()

private func previewHTMLGen(theme: String, scale: CGFloat, content: String) -> String {
    return """
    <html>
    <head>
    <meta charset="UTF-8">
    <script src="http://obb77efas.bkt.clouddn.com/highlight.pack.js"></script>
    <style type = "text/css">
    \(theme)
    </style>
    <script>
    window.oct_scroll = function(r) {
    let bodyH = document.body.offsetHeight
    let clientH = document.body.clientHeight
    let outH = bodyH - clientH
    if (outH < 0) {
    outH = 0
    }
    console.log(bodyH, outH, clientH, r)
    document.body.scrollTop = r * outH
    }
    </script>
    </head>
    <body>
        \(content)
    </body>
    <script>hljs.initHighlightingOnLoad();</script>
    <script>window.onload = function() { window.oct_scroll(\(scale));} </script>
    </html>
    """
}

class ViewController: NSViewController, NSTextStorageDelegate, WKNavigationDelegate, NSTextViewDelegate {
    
    var textView: NSTextView {
        
        return scrollView.documentView as! NSTextView
    }
    
    var offsetRatio: CGFloat {
        
        let height = scrollView.documentView!.frame.size.height
        let viewHeight = scrollView.frame.size.height
        var outH = height - viewHeight
        
        if outH < 0 {
            outH = 0
        }
        return scrollView.contentView.bounds.origin.y / outH
    }
    
    var testText: String {
        
        let path = Bundle.main.path(forResource: "Test", ofType: "md")!
        return try! String(contentsOfFile: path)
    }
 
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(white: 0.8, alpha: 1).cgColor
        configTextView()
        configScrollView()
        webView.navigationDelegate = self

        let text = testText
        textView.string = text
        if let html = MarkdownParser.toHTML(text).map(curry(previewHTMLGen)(theme)(offsetRatio)) {
            self.webView.loadHTMLString(html, baseURL: URL(string: "markright://markdown"))
        }
    }
    
    func configScrollView() {
        
        scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.autoScrollWebView), name: NSView.boundsDidChangeNotification, object: nil)
    }
    
    @objc func autoScrollWebView() {
        
        webView.evaluateJavaScript("window.oct_scroll(\(offsetRatio))", completionHandler: nil)
    }
    
    func configTextView() {
        
        textView.isEditable = true
        textView.backgroundColor = .white
        textView.font = NSFont.systemFont(ofSize: 16)
        textView.textColor = NSColor(white: 0.2, alpha: 1)
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.enabledTextCheckingTypes = 0
        textView.textStorage?.delegate = self
        textView.delegate = self
    }
    
    //    MARK: NSTextStorageDelegate
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        let text = textView.string
        let ratio = self.offsetRatio
    
        DispatchQueue.global(qos: .default).async {
            if let html = MarkdownParser.toHTML(text).map(curry(previewHTMLGen)(theme)(ratio)) {
                DispatchQueue.main.async {
                    self.webView.loadHTMLString(html, baseURL: URL(string: "markright://markdown"))
                }
            } else {
                print("failed")
            }
        }
    }
    
    //    MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url?.scheme == "markright" {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url {
            NSWorkspace.shared.open(url)
        }
        decisionHandler(.cancel)
    }
    
    //    MARK: NSTextViewDelegate
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        if commandSelector == #selector(textView.insertTab(_:)) {

            textView.insertText("    ", replacementRange: textView.selectedRange())
            return true
        }
        return false
    }
}

