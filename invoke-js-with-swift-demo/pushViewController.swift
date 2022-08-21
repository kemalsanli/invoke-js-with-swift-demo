//
//  pushViewController.swift
//  invoke-js-with-swift-demo
//
//  Created by Kemal Sanli on 21.08.2022.
//

import Foundation
import SnapKit
import UIKit
import Kingfisher

class PushViewController: UIViewController {
    
    lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.githubBlackColor
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.dissmissButtonImageName), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.downloadButtonImageName), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.imageViewPlaceHolderImageName)
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        configureViews()
        displayImage()
    }
    
    func configureViews() {
        //Main view subviews
        view.addSubview(topBar)
        view.addSubview(imageView)
        
        //TopBar subviews
        topBar.addSubview(dismissButton)
        topBar.addSubview(downloadButton)
        
        topBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview() //equalTo(view.safeAreaLayoutGuide.snp.bottom) tbh looks better without this
            make.left.right.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(16)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    func displayImage() {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        imageView.kf.setImage(with: url)
    }
    
    @objc func dismissButtonAction() {
        self.dismiss(animated: true)
    }
    
    func failedAlert() {
        let alert = UIAlertController(title: Constants.alertTitle , message: Constants.alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.alertButton, style: .default)
        alert.addAction(action)
        self.show(alert, sender: nil)
    }
    
    @objc func downloadButtonAction() {
        guard let image = imageView.image else {
            failedAlert()
            return
        }
        //FIXME: Not sure why but not displaying save to camera roll option.
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

    }
    
}

private enum Constants {
    static let alertTitle: String = "Something went wrong"
    static let alertMessage: String = "Operation Failed"
    static let alertButton: String = "Okay"
    static let imageViewPlaceHolderImageName: String = "circle"
    static let downloadButtonImageName: String = "square.and.arrow.down.fill"
    static let dissmissButtonImageName: String = "multiply"
    static let githubBlackColor: UIColor = UIColor(rgb: 0x23292f)
}
