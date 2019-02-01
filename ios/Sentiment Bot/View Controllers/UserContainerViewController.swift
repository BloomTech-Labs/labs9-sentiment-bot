//
//  UserContainerViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/23/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class UserContainerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var userImageButton: UIButton!
    
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
        
        userImageButton.applyDesign()
        setupView()
    }
    
    
    // MARK: - Setup View
    private func setupView() {
        
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
                                    self.userImageButton.setBackgroundImage(image, for: .normal)
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
                        self.leftLabel.text = "Team ID: \(team?.code ?? 0)"
                    } else {
                        APIController.shared.getUserResponses(userId: UserDefaults.standard.userId) { (responses, error) in
                            self.responses = responses
                            if let error = error {
                                NSLog("Error getting user responses: \(error)")
                            } else {
                                DispatchQueue.main.async {
                                    if let number = self.responses?.count {
                                        self.leftLabel.text = "\(number) Feelz"
                                        self.rightLabel.text = "Last in \(responses?.first?.date ?? "N/A")"
                                    }
                                    
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
                self.userImageButton.setBackgroundImage(image, for: .normal)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSettingsScreen" {
            if let nav = segue.destination as? UINavigationController {
                let destination = nav.topViewController as! SettingsTableViewController
                destination.user = users
            }

        }
    }
}

extension UIButton {
    func applyDesign() {
        // userImageButton Effects
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        // Put shadow on button
//        self.backgroundColor = UIColor.darkGray
//        self.layer.borderWidth = 2.0
//        self.layer.shadowColor = UIColor.darkGray.cgColor
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 4.0
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        // Put frame around button
        //        userImageButton.layer.borderColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
    }
}
