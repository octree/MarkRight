//
//  ViewController.swift
//  MarkRight
//
//  Created by Octree on 2018/4/12.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSTextStorageDelegate, WKNavigationDelegate {
    
    var textView: NSTextView {
        
        return scrollView.documentView as! NSTextView
    }
    
 
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(white: 0.8, alpha: 1).cgColor
        configTextView()
        
        webView.navigationDelegate = self

        if let html = MarkdownParser.toHTML("") {
            self.webView.loadHTMLString(html, baseURL: URL(string: "markright://markdown"))
        }
        
        
        let testCase = """
        1. 123213
            1. 123123
        
        """
//        space.amount(0) *> orderedListMarker *> space *> listItemParagraph(depth: 1)
        print(depthOrderedList(depth: 1).parse(Substring(testCase)).debugDescription)
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
    }
    
    //    MARK: NSTextStorageDelegate
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        let string = textView.string
        DispatchQueue.global(qos: .default).async {
            if let html = MarkdownParser.toHTML(string) {
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
}

