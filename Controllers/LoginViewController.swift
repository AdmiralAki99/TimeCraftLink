//
//  LoginViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    private let spotifyLoginWebView: WKWebView = {
        let webViewPref = WKWebpagePreferences()
        webViewPref.allowsContentJavaScript = true
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.defaultWebpagePreferences = webViewPref
        let spotifyLoginWebView = WKWebView(frame: .zero,configuration: webViewConfig)
        return spotifyLoginWebView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(spotifyLoginWebView)
        spotifyLoginWebView.navigationDelegate = self
        guard let loginURL = Authentication.auth.loginURL else{
            return
        }
        
        spotifyLoginWebView.load(URLRequest(url: loginURL))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spotifyLoginWebView.frame = view.bounds
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let spotifyURL = spotifyLoginWebView.url else{
            return
        }
        
        let urlComponents = URLComponents(string: spotifyURL.absoluteString)
        
        guard let code = urlComponents?.queryItems?.first(where: {$0.name == "code"})?.value else{
            return
        }
        spotifyLoginWebView.isHidden = true
        print(code)
        Authentication.auth.generateToken(code: code){ [weak self] result in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.requestComplete?(result)
            }
        }
    }
    
    public var requestComplete: ((Bool) -> Void)?
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
