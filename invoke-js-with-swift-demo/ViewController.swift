//
//  ViewController.swift
//  invoke-js-with-swift-demo
//
//  Created by Kemal Sanli on 18.08.2022.
//

import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.backgroundColor = .red
        return navBar
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    
    lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var invokeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "circle" ), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        organizeElements()
        webViewConfiguration()
    }
    
    func organizeElements() {
        
        // Main view subviews
        view.addSubview(navigationBar)
        view.addSubview(webView)
        view.addSubview(bottomBar)
        
        // Bottom bar subviews
        bottomBar.addSubview(invokeButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        invokeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    @objc func invokeButtonAction() {
        let url = URL(string: Constants.githubRepoUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webViewConfiguration() {
        
        //Initialize Url
        let url = URL(string: Constants.githubRepoUrl)!
        webView.load(URLRequest(url: url))
        
    }

}

private enum Constants {
    static let githubUrl = "https://github.com/"
    static let githubRepoUrl = Constants.githubUrl + "kemalsanli/invoke-js-with-swift-demo"
}
