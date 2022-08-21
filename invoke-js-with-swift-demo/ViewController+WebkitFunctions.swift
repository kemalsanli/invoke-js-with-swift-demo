//
//  ViewController+WebkitFunctions.swift
//  invoke-js-with-swift-demo
//
//  Created by Kemal Sanli on 21.08.2022.
//

import Foundation
import WebKit

//WebKit Functions
extension ViewController {
    
    func webkitInitOperations() {
        //Initialize Url
        webkitLoadUrl( getRandomProfile() )
        
        //Set userName
        userNameTextfield.text = getUsername()
    }
    
    func webkitLoadUrl(_ url:String) {
        let url = URL(string: url )!
        webView.load(URLRequest(url: url))
    }
    
    func getUsername() -> String {
        var usernamePath = webView.url?.path
        usernamePath?.removeFirst()
        return usernamePath ?? Constants.somethingWentWrong
    }
    
    func getWebViewConfiguration() -> WKWebViewConfiguration? {
        //Config
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        userContentController.add(self, name: Constants.messageHandlerName)
        config.userContentController = userContentController
        
        
        //For adding scripts.js file path and content
        guard let scriptPath = Bundle.main.path(forResource: "scripts", ofType: "js"),
              let scriptSource = try? String(contentsOfFile: scriptPath) else { return nil }

        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        userContentController.addUserScript(userScript)
        
        return config
    }
    
    func getRandomProfile() -> String {
        //Since we're working together with Ege I had to do this ^^
        let profiles: Set = [Constants.profileUrlEge, Constants.profileUrlKemal]
        return profiles.first ?? Constants.profileUrlKemal
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == Constants.messageHandlerName {
            
            //Check is it Dictionary
            if let dictionary = message.body as? Dictionary<String, AnyObject> {
                print(dictionary)
            } else {
                print(message.body)
                
                if let receivedString = message.body as? String {
                    
                    if waitingForHostName {
                        showAlert(receivedString)
                    }
                    
                    if waitingForProfilePicture {
                        showWithPushView(receivedString)
                    }
                }
                
            }
            
        }
    }
}

extension WKWebView {
    func stringByEvaluatingJavaScript(script: String) {
        self.evaluateJavaScript(script) { (result, error) in
            
        }
    }
}

private enum Constants {
    static let githubUrl: String = "https://github.com/"
    static let githubRepoUrl: String = Constants.githubUrl + "kemalsanli/invoke-js-with-swift-demo"
    static let profileUrlKemal: String = Constants.githubUrl + "kemalsanli"
    static let profileUrlEge: String = Constants.githubUrl + "egementrk"
    static let messageHandlerName: String = "someNameThatIsNotImportant"
    static let somethingWentWrong: String = "Looks like something went wrong."
}
