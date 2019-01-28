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
    
    var survey: Survey?
    
    var emojiSelection: [String] = ["😄" ,"😃","😢","😊","😞", "😡"]
    
    var selectedEmoji: String?
    
    var selectedSchedule: String?
    
    var selectedTime: Date?
    
    var scheduleSelection: [String] = ["Daily", "Weekly", "Monthly", "Now"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Select Schedule")
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.title = "Schedule"
                $0.options = scheduleSelection
                $0.value = survey?.schedule.capitalized
            }
            <<< TimeRow(){
                $0.title = "Time"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Send"
                }
                .onCellSelection { [weak self] (cell, row) in
                    NSLog("Pressed Send")
            }
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
            }
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
                        row.cell.height = ({ return (self.parent?.view.frame.height)!/5 })
                        row.cell.textLabel?.font =  UIFont(name:"Avenir", size: (self.parent?.view.frame.height)!/10)
                    }
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Add a Feeling"
                }
                .onCellSelection { [weak self] (cell, row) in
                    NSLog("Pressed Add a Feeling")
                    row.section?.form?.validate()
        }
    }
    
    
    
    
    
}
