//
//  UserContainerViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/23/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class UserContainerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var userImageButton: UIButton!
    
    // MARK: - Properties
    
    var responses: [Response]? = []
    var users: User?
    var team: Team?
    var teamName = "Moin's Team"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageButton.applyDesign()
        setupView()
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        
        APIController.shared.getUser(userId: UserDefaults.standard.userId) { (users, error) in
            self.users = users
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
            APIController.shared.getManagingTeam(userId: UserDefaults.standard.userId) { (team, error) in
                self.team = team
                if let error = error {
                    NSLog("Error getting managing team: \(error)")
                } else {
                    guard let admin = self.users?.isAdmin else { return }
                    if admin {
                        
                        let font = UIFont.boldSystemFont(ofSize: 14)
                        let attributes: [NSAttributedString.Key: Any] = [.font: font]
                        
                        let teamCode = NSMutableAttributedString(string: "\(team?.code ?? 0)", attributes: attributes)
                        let teamCodeString = NSAttributedString(string: "\nTeam ID")
                        teamCode.append(teamCodeString)
                        
                        let userCount = NSMutableAttributedString(string: "\(team?.users?.count ?? 0)", attributes: attributes)
                        let userCountString = NSAttributedString(string: "\nUsers")
                        userCount.append(userCountString)
                        
                        let teamName = NSMutableAttributedString(string: "\(team?.teamName ?? "Moin's team")", attributes: attributes)
                        let teamString = NSAttributedString(string: "\nTeam Name")
                        teamName.append(teamString)
                        
                        DispatchQueue.main.async {
                            self.leftLabel.attributedText = userCount
                            self.middleLabel.attributedText = teamName
                            self.rightLabel.attributedText = teamCode
                        }
                    } else {
                        if ((self.users?.isTeamMember)!) {
                            APIController.shared.getUserResponses(userId: UserDefaults.standard.userId) { (responses, error) in
                                self.responses = responses
                                if let error = error {
                                    NSLog("Error getting user responses: \(error)")
                                } else {
                                    if let number = self.responses?.count {
                                        var dateString = "N/A"
                                        if number != 0 {
                                            let inputFormatter = DateFormatter()
                                            inputFormatter.dateFormat = "yyyy-MM-dd"
                                            let showDate = inputFormatter.date(from: (self.responses?.first?.date) ?? "")
                                            inputFormatter.dateFormat = "MMM dd"
                                            dateString = inputFormatter.string(from: showDate!)
                                        }
                                        
                                        let font = UIFont.boldSystemFont(ofSize: 14)
                                        let attributes: [NSAttributedString.Key: Any] = [.font: font]
                                        
                                        let feelzNumber = NSMutableAttributedString(string: "\(number)", attributes: attributes)
                                        let feelzString = NSAttributedString(string: "\nFeelz")
                                        feelzNumber.append(feelzString)
                                        
                                        let teamName = NSMutableAttributedString(string: "\(self.teamName)", attributes: attributes)
                                        let teamString = NSAttributedString(string: "\nTeam Name")
                                        teamName.append(teamString)
                                        
                                        let lastInDate = NSMutableAttributedString(string: "\(dateString)", attributes: attributes)
                                        let lastInString = NSAttributedString(string: "\nLast In")
                                        lastInDate.append(lastInString)
                                        
                                        DispatchQueue.main.async {
                                            self.leftLabel.attributedText = feelzNumber
                                            self.middleLabel.attributedText = teamName
                                            self.rightLabel.attributedText = lastInDate
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if let error = error {
                NSLog("Error getting user: \(error)")
            } else {
                if (users?.isTeamMember)! {
                    APIController.shared.getTeam(teamId: users?.teamId ?? 0) { (team, error) in
                        self.team = team
                        if let error = error {
                            NSLog("Error getting Team Name \(error)")
                        } else {
                            self.teamName = team?.teamName ?? "None"
                        }
                    }
                }
                guard let firstName = users?.firstName, let lastName = users?.lastName else { return }
                DispatchQueue.main.async {
                    self.nameLabel.text = "\(firstName.capitalized) \(lastName.capitalized)"
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
        userImageButton.setBackgroundImage(image, for: .normal)
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
