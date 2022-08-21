//
//  ViewController.swift
//  invoke-js-with-swift-demo
//
//  Created by Kemal Sanli on 18.08.2022.
//

import UIKit
import SnapKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    lazy var navigationBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = Constants.githubBlackColor
        return navBar
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: getWebViewConfiguration() ?? WKWebViewConfiguration() )
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.isUserInteractionEnabled = false
        return webView
    }()

    
    lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.githubBlackColor
        return view
    }()
    
    lazy var invokeButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.buttonTitle , for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var hostButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.alertTitle, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(hostButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var userNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .systemGray4
        textfield.addPadding(padding: .equalSpacing(10))
        textfield.placeholder = Constants.textFieldPlaceholder
        textfield.layer.cornerRadius = 6
        textfield.layer.masksToBounds = true
        return textfield
    }()
    
    lazy var goButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.goButton, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
        return button
    }()
    
    var waitingForProfilePicture = false
    var waitingForHostName = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleStyling()
        organizeElements()
        webkitInitOperations()
    }
    
    func handleStyling() {
        view.backgroundColor = Constants.githubBlackColor
    }
    
    func organizeElements() {
        
        // Main view subviews
        view.addSubview(navigationBar)
        view.addSubview(webView)
        view.addSubview(bottomBar)
        
        //NavigationBar subviews
        navigationBar.addSubview(goButton)
        navigationBar.addSubview(userNameTextfield)
        
        // BottomBar subviews
        bottomBar.addSubview(invokeButton)
        bottomBar.addSubview(hostButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        goButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(25)
        }
        
        userNameTextfield.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(goButton.snp.leading).inset(-16)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        invokeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        hostButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
    }
    
    @objc func goButtonAction() {
        guard let text = userNameTextfield.text, !text.contains("/") else {
            failedAlert()
            return
        }
        
        let url = Constants.githubUrl + text
        webkitLoadUrl(url)
        
    }
    
    @objc func invokeButtonAction() {
        self.webView.stringByEvaluatingJavaScript(script: "javascript:getUserProfilePicture();")
        waitingForProfilePicture = true
    }
    
    @objc func hostButtonAction() {
        self.webView.stringByEvaluatingJavaScript(script: "javascript:getHostname();")
        waitingForHostName = true
    }
    
    func showWithPushView(_ with: String) {
        waitingForProfilePicture = false
        
        let vc = PushViewController()
        vc.imageUrl = with
        self.show(vc, sender: nil)
    }
    
    func showAlert(_ with: String) {
        waitingForHostName = false
        let alert = UIAlertController(title: Constants.alertTitle , message: with, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.okayButton , style: .default)
        alert.addAction(dismissAction)
        self.show(alert, sender: nil)
    }
    
    func failedAlert() {
        let alert = UIAlertController(title: Constants.errorTitle , message: Constants.alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.okayButton, style: .default)
        alert.addAction(action)
        self.show(alert, sender: nil)
    }
}


private enum Constants {
    static let githubUrl: String = "https://github.com/"
    static let okayButton: String = "OK"
    static let alertTitle: String = "Hostname"
    static let goButton: String = "Go"
    static let buttonTitle: String = "Get Profile Picture"
    static let githubBlackColor: UIColor = UIColor(rgb: 0x23292f)
    static let errorTitle: String = "Something went wrong"
    static let alertMessage: String = "You did something wrong."
    static let textFieldPlaceholder: String = "Enter Username"
    static let somethingWentWrong: String = "Looks like something went wrong."
}
