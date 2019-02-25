//
//  TimelineViewController.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/10/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn

class TimelineViewController: UIViewController, UserProtocol, TimeLineTableViewCellDelegate {
    
    func selectImage(on cell: TimeLineTableViewCell) {
        guard let indexPath = timelineTableView.indexPath(for: cell) else { return }
        responseID = userResponses?[indexPath.row].id
        takeSelfie(cell: cell)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var timelineTableView: UITableView!

    // MARK: - Properties
    var user: User?
    var userResponses: [Response]? {
        didSet {
            updateViews()
        }
    }
    
    var feelzImage: UIImage?
    var responseID: Int?
    
    var newCell: TimeLineTableViewCell?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.layoutMargins = UIEdgeInsets.zero
        timelineTableView.separatorInset = UIEdgeInsets.zero

        if #available(iOS 10.0, *) {
            timelineTableView.refreshControl = refreshControl
        } else {
            timelineTableView.addSubview(refreshControl)
        }
        
        updateViews()
    }
    
    // MARK: - Private Functions
    private func updateViews() {
        DispatchQueue.main.async {
            self.timelineTableView?.reloadData()
        }
    }
    
    // MARK: - Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refreshUserResponses(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc func refreshUserResponses(_ refreshControl: UIRefreshControl) {
        APIController.shared.getUserResponses(userId: UserDefaults.standard.userId, completion: { (responses, error) in
            DispatchQueue.main.async {
                self.userResponses = responses
                self.timelineTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
}

// MARK: - TableView DataSourse and Delegate
extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userResponses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = userResponses![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelzCell") as! TimeLineTableViewCell
        cell.delegate = self
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        cell.feelzImageView.layer.cornerRadius = cell.feelzImageView.frame.size.width / 2
        cell.feelzImageView.layer.masksToBounds = true
        if let imageUrl = response.imageUrl {
            APIController.shared.getImage(url: imageUrl) { (image, error) in
                if let error = error {
                    NSLog("Error getting image \(error)")
                } else if let image = image {
                    DispatchQueue.main.async {
                        cell.feelzImageView.image = image
                    }
                }
            }
        }
        cell.setResponse(response: response)
        return cell
    }
}

// MARK: - Image Picker
extension TimelineViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func imagePickerButton(_ sender: UIButton) {
        //takeSelfie(cell: TimeLineTableViewCell)
    }
    
    func takeSelfie(cell: TimeLineTableViewCell) {
        newCell = cell
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        // For iPad
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
        
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
        picker.view.tintColor = .white
        picker.view.backgroundColor = .white
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            NSLog("No image found")
            return
        }
        newCell?.feelzImageView.image = image
        guard let imageData = image.pngData(), let responseID = responseID else {
            dismiss(animated: true, completion: nil)
            return
            
        }
        
        
        APIController.shared.uploadResponseSelfie(responseId: responseID, imageData: imageData) { (errorMessage) in
            if let errorMessage = errorMessage {
                NSLog("Error uploading response selfie: \(errorMessage)")
            }
//            APIController.shared.getUserResponses(userId: UserDefaults.standard.userId, completion: { (responses, error) in
//                DispatchQueue.main.async {
//                    self.userResponses = responses
//                    self.timelineTableView.reloadData()
//                }
//            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
