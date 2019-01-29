//
//  SendSurveyFormViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/26/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import Eureka

class SendSurveyFormViewController: FormViewController, ManagerProtocol {
    var teamMembers: [User]?
    
    var user: User?
    
    var teamResponses: [Response]?
    
    var team: Team?
    
    var survey: Survey? {
        didSet {
            selectedSchedule = survey?.schedule
            selectedTime = convertStringToTime(time: (survey?.time)!)
        }
    }
    
    var emojiSelection: [String] = ["😄" ,"😃","😢","😊","😞", "😡"]
    
    var selectedEmoji: String?
    
    var selectedSchedule: String?
    
    var selectedTime: Date?
    
    var feelingName: String?
    
    var scheduleSelection: [String] = ["Daily", "Weekly", "Monthly", "Now"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func convertStringToTime(time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: time) else {
            NSLog("Invalid Military Time Format in String")
            return Date()
        }
        return date
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Select Schedule")
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.title = "Schedule"
                $0.options = scheduleSelection
                $0.value = survey?.schedule.capitalized
                }.onChange({ row in
                    self.selectedSchedule = row.value
                })
            <<< TimeRow(){
                guard let time = survey?.time else {
                    NSLog("Time wasn't set on survey in SendSurveyFormViewController")
                    return
                }
                $0.title = "Time"
                $0.value = convertStringToTime(time: time)
                }.onChange({ (row) in
                    self.selectedTime = row.value
                })
//            <<< ButtonRow() { (row: ButtonRow) -> Void in
//                row.title = "Schedule"
//                }
//                .onCellSelection { [weak self] (cell, row) in
//                    guard let selectedTime = self?.selectedTime,
//                        let selectedSchedule = self?.selectedSchedule,
//                        let survey = self?.survey else {
//                            NSLog("selectedTime and selectedSchedule weren't set on SendSurveyFormViewController")
//                            return
//                    }
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "HH:mm"
//                    let timeString = dateFormatter.string(from: selectedTime)
//
//                    APIController.shared.changeSurveySchedule(surveyId: survey.id, time: timeString, schedule: selectedSchedule, completion: { (errorMessage) in
//
//                        let managementViewController = self?.parent?.parent?.children.first as! ManagementViewController
//
//                        managementViewController.survey?.schedule = selectedSchedule
//
//                    })
//            }
            +++ Section("Add a Feeling")
            <<< TextRow(){ row in
                row.title = "Feeling:"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }.onChange({ (row) in
                    self.feelingName = row.value
                })
            <<< PushRow<String>() {
                $0.title = "Select Emoji"
                $0.options = ["😄" ,"😃","😢","😊","😞", "😡"]
                $0.value = "😄"
                $0.selectorTitle = "Emojis"
                }.onPresent { from, to in
                    to.dismissOnSelection = true
                    to.dismissOnChange = false
                    to.enableDeselection = false
                    to.selectableRowSetup = { row in
                        row.cell.height = ({ return (self.parent?.view.frame.height)!/8 })
                        row.cell.textLabel?.font =  UIFont(name:"Avenir", size: (self.parent?.view.frame.height)!/10)
                }}
                .onChange{ (row) in
                    self.selectedEmoji = row.value
                }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Add a Feeling"
                }
                .onCellSelection { [weak self] (cell, row) in
                    row.section?.form?.validate()
                    guard let mood = self?.feelingName,
                        let emoji = self?.selectedEmoji,
                        let survey = self?.survey else {
                            NSLog("Mood and Emoji weren't entered on Form")
                            return
                    }
                    APIController.shared.createFeelingForSurvey(mood: mood, emoji: emoji, surveyId: survey.id, completion: { (feeling, errorMessage) in
                        if let feeling = feeling {
                            let sendSurveyViewController = self?.parent as! SendSurveyViewController
                            DispatchQueue.main.async {
                                sendSurveyViewController.feelings?.append(feeling)
                                let managementViewController = sendSurveyViewController.parent?.children.first as! ManagementViewController
                                managementViewController.survey?.feelings?.append(feeling)
                                sendSurveyViewController.tableView.reloadData()
                            }
                        } else if let errorMessage = errorMessage {
                            
                        }

                    })
        }
    }
    
    
    
    
    
}
