//
//  UserContainerViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/23/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class UserContainerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feelzNumberLabel: UILabel!
    @IBOutlet weak var lastInLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var teamIDLabel: UILabel!
    
    var responses: [Response]? = []
    var users: User?
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        // TODO: - Should this be in awakeFromNib?
        
        APIController.shared.getUser(userId: UserDefaults.standard.userId) { (users, error) in
            self.users = users
            DispatchQueue.main.async {
                guard let firstName = users?.firstName, let lastName = users?.lastName, let userID = users?.id else { return }
                self.nameLabel.text = "\(firstName) \(lastName) (\(userID))"
                
                if let imageUrl = users?.imageUrl {
                    APIController.shared.getImage(url: imageUrl) { (image, error) in
                        if let error = error {
                            NSLog("Error getting image \(error)")
                        } else if let image = image {
                            DispatchQueue.main.async {
                                self.userImage.image = image
                                
                            }
                        }
                    }
                }
            }
        }
        
        APIController.shared.getUserResponses(userId: UserDefaults.standard.userId) { (responses, error) in
            self.responses = responses
            DispatchQueue.main.async {
                self.feelzNumberLabel.text = "Feelz: \(self.responses?.count ?? 0)"
                self.lastInLabel.text = "Last In: \(responses?.last?.date ?? " ")"
            }
        }
        
        APIController.shared.getManagingTeam(userId: UserDefaults.standard.userId) { (team, error) in
            self.team = team
            
            DispatchQueue.main.async {
                guard let admin = self.users?.isAdmin else { return }
                if admin {
                    self.teamIDLabel.text = "Team ID: \(team?.code ?? 0)"
                } else {
                    self.teamIDLabel.text = ""
                }
            }
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBAction func selectImage(_ sender: UIButton) {
        NSLog("Select Image")
        
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
        userImage.image = image
        let imageData = image.pngData()
        
        APIController.shared.uploadProfilePicture(imageData: imageData!) { (error) in
            if let error = error {
                NSLog("Error uploading: \(error)")
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
