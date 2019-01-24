//
//  TimelineViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class TimelineViewController: UIViewController, UserProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var user: User?
    
    var userResponses: [Response]? {
        didSet {
            updateViews()
        }
    }
    
    var feelzImage: UIImage?
    
    private func updateViews() {
        DispatchQueue.main.async {
            //self.timelineTableView.isHidden = false
            self.timelineTableView?.reloadData()
        }
    }
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    
    // TODO: - ViewDidAppear does not run after modal, fix
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        guard let userAuth = GIDSignIn.sharedInstance()?.hasAuthInKeychain() else { return }
//        if !userAuth {
//            NSLog("User not logged in")
//        } else {
//            NSLog("User still logged in")
//        }
//    }
    
    @IBAction func imagePickerButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
            vc.cameraDevice = .front
        } else {
            vc.sourceType = .photoLibrary
        }
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            NSLog("No image found")
            return
        }
        // TODO: - put image in Response array
        print(image.size)
        let imageData = image.pngData()!
        APIController.shared.uploadResponseSelfie(responseId: 1, imageData: imageData) { (errorMessage) in
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = userResponses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelzCell") as! TimeLineTableViewCell
        cell.setResponse(response: response)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
