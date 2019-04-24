//
//  ManagmentViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/26/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD

class ManagementViewController: UIViewController, ManagerProtocol, UNUserNotificationCenterDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var currentScheduleLabel: UILabel!
    @IBOutlet weak var sendSurveyButton: UIButton!
    @IBOutlet weak var sendNowButton: UIButton!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    @IBOutlet weak var subscriptionButton: UIButton!
    //@IBOutlet weak var msgBox: UITextView!
    
    // MARK: - Properties
    
    var user: User?
    var teamResponses: [Response]?
    var team: Team?
    var survey: Survey?
    var teamMembers: [User]?
    var stripeToken: String?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendSurveyButton.applyDesign()
        sendNowButton.applyDesign()
        setSchedule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        sendSurveyButton.applyDesign()
        sendNowButton.applyDesign()
        sendNowButton.applyDesign()
        sendSurveyButton.applyDesign()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSchedule()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Private Functions
    
    private func setSchedule() {
        guard let survey = survey else {
            NSLog("Survey wasn't set on ManagementViewController")
            return
        }
        self.currentScheduleLabel.text = "Schedule: \(survey.schedule.capitalized)"
        self.nextDateLabel.text = "Date: \(survey.targetDate)"
        self.nextTimeLabel.text = "Time: \(survey.formattedTime)"

//
//        UNUserNotificationCenter.current().getPendingNotificationRequests {
//            (requests) in
//            var nextTriggerDates: [String] = []
//            for request in requests {
//                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
//                    let triggerDate = trigger.nextTriggerDate(){
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.timeZone = NSTimeZone.local
//                    dateFormatter.dateFormat = "MM/dd/yyyy h:mm:a"
//                    let triggerDate = dateFormatter.string(from: triggerDate)
//                    let triggerDateArray = triggerDate.components(separatedBy: " ")
//                    let date = triggerDateArray.first!
//                    let time = triggerDateArray.last!
//                    DispatchQueue.main.async {
//                        self.currentScheduleLabel.text = "Schedule: \(survey.schedule.capitalized)"
//                        self.nextDateLabel.text = "Date: \(date)"
//                        self.nextTimeLabel.text = "Time: \(time)"
//                    }
//                    nextTriggerDates.append(triggerDate)
//                    print("TRIGGER DATES: \(nextTriggerDates)")
//                }
//            }
//            if let nextTriggerDate = nextTriggerDates.min() {
//                print("NEXT TRIGGER DATE: \(nextTriggerDate)")
//            }
//        }
        
    }
    
    @IBAction func sendNow(_ sender: Any) {
        let progressWithStatus = SVProgressHUD.self
        progressWithStatus.setBackgroundColor(Theme.current.mainColor)
        progressWithStatus.show(withStatus: "Sending...")
        guard let survey = survey else {
                NSLog("User and Survey wasn't set on ManagementViewController")
                return
        }
        APIController.shared.changeSurveySchedule(surveyId: survey.id, time: survey.time, schedule: "Now") { (_, errorMessage) in
            progressWithStatus.showSuccess(withStatus: "Sent")
            progressWithStatus.dismiss(withDelay: 1)
        }
    }


    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSendSurveyViewController" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! SendSurveyViewController
            destination.teamResponses = teamResponses
            destination.survey = survey
            destination.user = user
            destination.team = team
        }
     }

}
