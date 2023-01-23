//
//  AdvWebviewViewController.swift
//  UnifiIntegratonApp
//
//  Created by Naresh Gujjari on 11/20/22.
//

import WebKit
import UIKit

class AdvWebviewViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
  
    // https://www.innominds.com/blog/wkwebview-to-native-code-interaction
    
    private let url: URL
    
    init(url: URL, title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    lazy var webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let contentController = WKUserContentController()
       
       // let scriptSource = "document.body.style.backgroundColor = `Aqua`;"
        let scriptSource = "var jsonObj = {syfPartnerId:\"PI53421676\",tokenId:\"185df7a6fefPI5342167627741\",encryptKey:\"\",modalType:\"\",childMid:\"\",childPcgc:\"\",childTransType:\"\",pcgc:\"\",partnerCode:\"\",clientToken:\"\",postbackid:\"d979e5b7-6382-4e4e-b269-aab027bbed58\",clientTransId:\"\",cardNumber:\"\",custFirstName:\"\",custLastName:\"\",expMonth:\"\",expYear:\"\",custZipCode:\"\",custAddress1:\"\",phoneNumb:\"\",appartment:\"\",emailAddr:\"\",custCity:\"\",upeProgramName:\"\",custState:\"\",transPromo1:\"\",iniPurAmt:\"\",mid:\"\",productCategoryNames:\"\",transAmount1:\"700\",transAmounts:\"\",initialAmount:\"\",envUrl:\"https://dpdpone.syfpos.com/mitservice/\",productAttributes:\"\",processInd:\"3\"};"
        
       // let scriptSource = "document.body.style.backgroundColor = `white`;"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        contentController.add(self, name: "syfclosemodal")
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("Webview redirect .....")
           if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    let host = url.host, !host.hasPrefix("https://dpdpone.syfpos.com"), // Webview target URL Prefix. All others will open in safari.
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    print(url)
                    print("Redirected to browser. No need to open it locally")
                    decisionHandler(.cancel)
                    return
                } else {
                    print("Open it locally")
                    decisionHandler(.allow)
                    return
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
                return
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
  
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
    }

    @objc private func didTapDone() {
        webView.evaluateJavaScript("onWebViewDoneCloseModal()")
       // dismiss(animated: true, completion: nil)
    }
    
    /// Assuming that the javascript sends message back, this function handles the message
            ///
            /// - Parameters:
            ///   - userContentController: controller
            ///   - message: Message. Can be a String or [String:Any] to a single level.
  
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("User message received.... \(message.body)" )
        if let dict = message.body as? [String : AnyObject],
           let syfMessage = dict["message"] as? String{
            print("syfMessage  \(syfMessage)")
            if(syfMessage == "syf-close-modal"){
                dismiss(animated: true, completion: nil)
            }
        }
        else {
            return
        }
        
    }
}


