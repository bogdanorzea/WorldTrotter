//
//  WebsiteViewController.swift
//  WorldTrotter
//
//  Created by Bogdan Orzea on 2/18/19.
//  Copyright © 2019 Bogdan Orzea. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.bignerdranch.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
