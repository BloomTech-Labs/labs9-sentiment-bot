//
//  SendSurveyViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

class SendSurveyViewController: UIViewController, ManagerProtocol {
    var teamMembers: [User]?
    
    var user: User?
    
    var teamResponses: [Response]?
    
    var team: Team?
    
    var survey: Survey?
    
    var emojiSelection: [String] = ["😄" ,"😃","😢","😊","😞", "😡"]
    
    var scheduleSelection: [String] = ["daily", "weekly", "monthly", "now"]
    
    var emojiSelectionIsHidden: Bool = true
    var scheduleSelectionIsHidden: Bool = true
    
    var feelings: [Feeling] {
        return survey?.feelings ?? []
    }
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(SendSurveyViewController.dateChanged(datePicker:)), for: .valueChanged)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SendSurveyViewController.viewTapped(gestureRecognizer:)))
//
//        view.addGestureRecognizer(tapGesture)
        
        timeTextField.inputView = datePicker
        
        selectScheduleButtonDrop.setTitle(survey?.schedule, for: .normal)
        
        emojiSelectionTableView.isHidden = true
        scheduleSelectionTableView.isHidden = true
 
        emojiSelectionTableView.dataSource = self
        scheduleSelectionTableView.dataSource = self
        surveyFeelingsTableView.dataSource = self
        
        emojiSelectionTableView.delegate = self
        scheduleSelectionTableView.delegate = self
        surveyFeelingsTableView.delegate = self
        
    }
    @IBAction func onClickEmojiSelectionDropButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.emojiSelectionTableView.isHidden = !self.emojiSelectionIsHidden
        }
        emojiSelectionIsHidden = !emojiSelectionIsHidden
    }
    
    @IBAction func onClickScheduleSelectionDropButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.scheduleSelectionTableView.isHidden = !self.scheduleSelectionIsHidden
        }
        scheduleSelectionIsHidden = !scheduleSelectionIsHidden
    }
    
    
    @IBOutlet weak var emojiSelectionButtonDrop: UIButton!
    
    @IBOutlet weak var selectScheduleButtonDrop: UIButton!
    
    @IBOutlet weak var emojiSelectionTableView: UITableView!
    
    @IBOutlet weak var scheduleSelectionTableView: UITableView!
    
    @IBOutlet weak var surveyFeelingsTableView: UITableView!
    
    @IBOutlet weak var moodTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBAction func addToFeelings(_ sender: Any) {
        guard let mood = moodTextField.text else { return }
        APIController.shared.createFeelingForSurvey(mood: mood, emoji: (emojiSelectionButtonDrop.titleLabel?.text)!,surveyId: (survey?.id)!) { (errorMessage) in
            
            APIController.shared.getFeelingsForSurvey(surveyId: (self.survey?.id)!, completion: { (feelings, errorMessage) in
                DispatchQueue.main.async {
                    self.survey?.feelings = feelings
                    self.surveyFeelingsTableView.reloadData()
                }
            })
        }
    }
    
    //TODO: Make sure I can send out Survey to Users. Need to be
    //Tested on iOS and Backend Server.
    @IBAction func sendOutSurvey(_ sender: Any) {
        let schedule = selectScheduleButtonDrop.titleLabel?.text
        let deviceToken = UserDefaults.standard.deviceToken ?? ""
        APIController.shared.changeSurveySchedule(deviceToken: deviceToken, surveyId: survey!.id, schedule: schedule!) { (errorMessage) in
            if let errorMessage = errorMessage {
                NSLog("Error sending survey: \(errorMessage)")
            }
        }
    }
    
    // MARK: - DatePicker
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        timeTextField.text = dateFormatter.string(from: datePicker.date)
        print(timeTextField.text!)
        //        view.endEditing(true)
    }

}
//Todo: Implement delete on UI and Backend of Feeling
extension SendSurveyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == emojiSelectionTableView {
            return emojiSelection.count
        } else if tableView == scheduleSelectionTableView {
            return scheduleSelection.count
        } else if tableView == surveyFeelingsTableView {
            return survey?.feelings?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let response = teamResponses![indexPath.row]
        if tableView == emojiSelectionTableView {
             let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiSelectionCell")!
            cell.textLabel?.text = emojiSelection[indexPath.row]
            return cell
        } else if tableView == scheduleSelectionTableView {
             let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSelectionCell")!
            cell.textLabel?.text = scheduleSelection[indexPath.row]
            return cell
        } else if tableView == surveyFeelingsTableView {
             let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyFeelingCell")!
             let feeling = survey?.feelings?[indexPath.row]
            
             cell.textLabel?.text = "\(feeling!.mood) \(feeling!.emoji)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == emojiSelectionTableView {
            let emoji = emojiSelection[indexPath.row]
            emojiSelectionButtonDrop.setTitle(emoji, for: .normal)
            onClickEmojiSelectionDropButton(self)
        } else if tableView == scheduleSelectionTableView {
            let schedule = scheduleSelection[indexPath.row]
            selectScheduleButtonDrop.setTitle(schedule, for: .normal)
            onClickScheduleSelectionDropButton(self)
        }
    }
    
}
