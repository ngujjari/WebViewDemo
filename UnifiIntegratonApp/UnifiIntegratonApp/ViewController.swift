//
//  ViewController.swift
//  UnifiIntegratonApp
//
//  Created by Naresh Gujjari on 11/20/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        view.addSubview(buttonSimpleWebView)
        view.addSubview(buttonAdvancedWebView)
        buttonSimpleWebView.addTarget(self, action: #selector(simpleWebViewTapAction), for: .touchUpInside)
        buttonAdvancedWebView.addTarget(self, action: #selector(advancedWebViewTapAction), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonSimpleWebView.frame = CGRect(
            x: 30,
            y: view.frame.size.height-150-view.safeAreaInsets.bottom,
            width: view.frame.size.width-60,
            height: 55
        )
        buttonAdvancedWebView.frame = CGRect(
            x: 30,
            y: view.frame.size.height-250-view.safeAreaInsets.bottom,
            width: view.frame.size.width-60,
            height: 55
        )
    }
// https://dpdpone.syfpos.com/mpp/mpp?partnerId=PI53421676&amount=666&syfToken=MPP1PI534216761669857468920&productCategoryNames=&flowType=PDP&cid=unifitestoo&adobe_mc=MCMID%3D11699604732310737292115892261680123387%7CMCORGID%3D22602B6956FAB4777F000101%2540AdobeOrg%7CTS%3D1669862489&_ga=2.173783395.1351517599.1669861855-1876618331.1669861855
    
    // https://dpdpone.syfpos.com/mit/?widgetload=y&amount=600&flowType=pdp&partnerId=PI53421676
    // https://dpdpone.syfpos.com/mit/?externalLogin=Y
    // https://www.electronicexpress.com
    // http://localhost
       /*
         - Modal alignment issues
         - Header lost on MPP checkout page
         
        */
    
    //
    @objc func simpleWebViewTapAction(){
        guard let url = URL(string: "https://dpdpone.syfpos.com/mit/?widgetload=y&amount=600&flowType=pdp&partnerId=PI53421676")
        else {
            return
        }
        
        let vc = WebviewViewController(url: url, title: "Merchant App")
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc func advancedWebViewTapAction(){
        guard let url = URL(string: "http://localhost") else {
            return
        }
        
        let vc = AdvWebviewViewController(url: url, title: "Synchrony Checkout")
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private let buttonSimpleWebView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Launch Merchant App In WebView", for: .normal)
        button.layer.cornerRadius = 10;
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let buttonAdvancedWebView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("SYF Checkout In WebView", for: .normal)
        button.setTitleShadowColor(.black, for: .normal)
        button.layer.cornerRadius = 10;
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
   
    
    
    
    
}

