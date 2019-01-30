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
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageButton.backgroundColor = .clear
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
//        userImage.layer.borderWidth = 3.0
//        userImage.layer.borderColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
        
        setupView()
    }
    
    
    // MARK: - Setup View
    func setupView() {
        
        APIController.shared.getUser(userId: UserDefaults.standard.userId) { (users, error) in
            self.users = users
            if let error = error {
                NSLog("Error getting user: \(error)")
            } else {
                DispatchQueue.main.async {
                    guard let firstName = users?.firstName, let lastName = users?.lastName else { return }
                    self.nameLabel.text = "\(firstName.capitalized) \(lastName.capitalized)"
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
        }
        
        APIController.shared.getManagingTeam(userId: UserDefaults.standard.userId) { (team, error) in
            self.team = team
            if let error = error {
                NSLog("Error getting managing team: \(error)")
            } else {
                DispatchQueue.main.async {
                    guard let admin = self.users?.isAdmin else { return }
                    if admin {
                        self.teamIDLabel.text = "Team ID: \(team?.code ?? 0)"
                    } else {
                        self.teamIDLabel.text = ""
                        APIController.shared.getUserResponses(userId: UserDefaults.standard.userId) { (responses, error) in
                            self.responses = responses
                            if let error = error {
                                NSLog("Error getting user responses: \(error)")
                            } else {
                                DispatchQueue.main.async {
                                    self.feelzNumberLabel.text = "Feelz: \(self.responses?.count ?? 0)"
                                    self.lastInLabel.text = "Last In: \(responses?.last?.date ?? " ")"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Load Profile Picture
    @IBAction func selectImage(_ sender: UIButton) {
            
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                self.openCamera()
            }))
            alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            // For iPad
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.sourceView = sender
                alert.popoverPresentationController?.sourceRect = sender.bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func openCamera() {
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.cameraDevice = .front
            } else {
                let alert  = UIAlertController(title: "Warning", message: "Your device does not have a camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            picker.allowsEditing = true
            present(picker, animated: true)
        }
        
        func openGallary() {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            NSLog("No image found")
            return
        }
        let imageData = image.pngData()
        
        APIController.shared.uploadProfilePicture(imageData: imageData!) { (error) in
            if let error = error {
                NSLog("Error uploading profile picture: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.userImage.image = image
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
