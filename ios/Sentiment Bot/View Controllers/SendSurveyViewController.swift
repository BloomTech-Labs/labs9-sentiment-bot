//
//  SendSurveyViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import Eureka
import SVProgressHUD
class SendSurveyViewController: UITableViewController, ManagerProtocol {
    
    var user: User?
    var teamResponses: [Response]?
    var team: Team?
    var survey: Survey? {
        didSet {
            feelings = survey?.feelings
        }
    }
    var feelings: [Feeling]?
    var teamMembers: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //title = "Schedule: Daily"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feelings?.count ?? 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelingCell", for: indexPath) as! FeelingTableViewCell
        let feeling = feelings?[indexPath.row]
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.setFeeling(feeling: feeling)
        return cell
     }
    
    @IBAction func scheduleSurvey(_ sender: Any) {
        let progressWithStatus = SVProgressHUD.self
        progressWithStatus.setBackgroundColor(Theme.current.mainColor)
        progressWithStatus.show()
        let sendSurveyViewController = self.children.first as! SendSurveyFormViewController
        let managementViewController = self.parent?.presentingViewController?.children.last?.children.last as! ManagementViewController
        let newSchedule = sendSurveyViewController.selectedSchedule!
        managementViewController.survey?.schedule = newSchedule
        //managementViewController.currentScheduleLabel.text = "Schedule: \(newSchedule)"
        let selectedTime = sendSurveyViewController.selectedTime!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: selectedTime)
        managementViewController.survey?.time = timeString
        self.survey?.time = timeString
        sendSurveyViewController.survey?.time = timeString
        APIController.shared.changeSurveySchedule(surveyId: survey!.id, time: timeString, schedule: newSchedule, completion: { (survey, errorMessage) in
            sendSurveyViewController.survey?.startDate = survey!.startDate
            managementViewController.survey?.startDate = survey!.startDate
            DispatchQueue.main.async {
                progressWithStatus.dismiss()
                self.dismiss(animated: true)
            }
        })
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     let feeling = feelings?[indexPath.row]
     feelings?.remove(at: indexPath.row)
     APIController.shared.removeFeelingFromSurvey(feelingId: (feeling?.id)!) { (errorMessage) in
            
     }
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
  
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSendSurveyForm" {
            let destination = segue.destination as! SendSurveyFormViewController
            destination.teamResponses = teamResponses
            destination.survey = survey
            destination.user = user
            destination.team = team
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Feelings"
    }
}
