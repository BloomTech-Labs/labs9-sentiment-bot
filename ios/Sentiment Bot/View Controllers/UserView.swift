//
//  UserView.swift
//  SentimentBotTest1
//
//  Created by Scott Bennett on 1/9/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

@IBDesignable class UserView: UIView, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feelzNumberLabel: UILabel!
    @IBOutlet weak var lastInLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    var view: UIView!
    var responses: [Response]? = []
    var users: User?
    
    // Gives storyboard access to outlets
    @IBInspectable var userImageImage: UIImage? {
        get {
            return userImage.image
        }
        
        set(userImageImage) {
            userImage.image = userImageImage
        }
    }
    
    override func awakeFromNib() {
        
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil) [0] as! UIView
        
        return view
    }
    

    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    @IBAction func selectImage(_ sender: UIButton) {
        NSLog("Select Image")
        
//        let vc = UIImagePickerController()
//        vc.sourceType = .camera
//        vc.allowsEditing = true
//        vc.delegate = self
//        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            NSLog("No image found")
            return
        }
        userImage.image = image
    }
}
