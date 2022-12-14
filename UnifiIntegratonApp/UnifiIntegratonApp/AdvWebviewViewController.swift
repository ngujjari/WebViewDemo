//
//  AdvWebviewViewController.swift
//  UnifiIntegratonApp
//
//  Created by Naresh Gujjari on 11/20/22.
//

import WebKit
import UIKit

class AdvWebviewViewController: UIViewController, WKScriptMessageHandler {
  
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
        let scriptSource = "var jsonObj = {syfPartnerId:\"PI53421676\",tokenId:\"185089a155bPI5342167644931\",encryptKey:\"\",modalType:\"\",childMid:\"\",childPcgc:\"\",childTransType:\"\",pcgc:\"\",partnerCode:\"\",clientToken:\"\",postbackid:\"d979e5b7-6382-4e4e-b269-aab027bbed58\",clientTransId:\"\",cardNumber:\"\",custFirstName:\"\",custLastName:\"\",expMonth:\"\",expYear:\"\",custZipCode:\"\",custAddress1:\"\",phoneNumb:\"\",appartment:\"\",emailAddr:\"\",custCity:\"\",upeProgramName:\"\",custState:\"\",transPromo1:\"\",iniPurAmt:\"\",mid:\"\",productCategoryNames:\"\",transAmount1:\"700\",transAmounts:\"\",initialAmount:\"\",envUrl:\"https://dpdpone.syfpos.com/mitservice/\",productAttributes:\"\",processInd:\"3\"};"
        
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
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
     if (error as NSError).code == -999 {
        return
     }
     print("\(error) unifi error ... " )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
       // webView.loadHTMLString("<!DOCTYPE html><html><head>Loading HTML</head><body><p>Hello!`</p></body></html>", baseURL: nil)
    
        /*
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            
            let data = Data(syfFormObj.utf8)
            webView.evaluateJavaScript("document.getElementById('syfCheckoutFormVal').value='\(data)'")
           
        } */
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
