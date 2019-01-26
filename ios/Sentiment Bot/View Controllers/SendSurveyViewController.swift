//
//  SendSurveyViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import Eureka
class SendSurveyViewController: FormViewController, ManagerProtocol {
    var teamMembers: [User]?
    
    var user: User?
    
    var teamResponses: [Response]?
    
    var team: Team?
    
    var survey: Survey?
    
    var emojiSelection: [String] = ["😄" ,"😃","😢","😊","😞", "😡"]
    
    var scheduleSelection: [String] = ["daily", "weekly", "monthly", "now"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Add a Feeling")
            <<< TextRow(){ row in
                row.title = "Feeling:"
                row.placeholder = "Enter text here"
            }
            <<< SegmentedRow<String>(){
                $0.title = "Choose an Emoji"
                $0.options = ["😄" ,"😃","😢","😊","😞", "😡"]
                $0.value = "😄"
                }.cellSetup { cell, row in
                    cell.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for:.selected)
            }
            
            <<< PushRow<String>() {
                $0.title = "Select Emoji"
                $0.options = ["😄" ,"😃","😢","😊","😞", "😡"]
                $0.value = "😄"
                $0.selectorTitle = "Emoji"
                }.onPresent { from, to in
                    to.dismissOnSelection = true
                    to.dismissOnChange = false
                    to.selectableRowSetup = { row in
                        row.cell.height = ({ return self.view.frame.height/5 })
                        row.cell.textLabel?.font =  UIFont(name:"Avenir", size: self.view.frame.height/10)
                    }
            }
            
            +++ Section("Select Schedule")
            <<< AlertRow<String>() {
                $0.title = "Schedule"
                //$0.cancelTitle = "Cancel"
                //$0.selectorTitle = "When should the survey be sent?"
                $0.options = ["Daily", "Weekly", "Monthly", "Now"]
                $0.value = survey?.schedule.capitalized
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< TimeRow(){
                $0.title = "Time"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
    
    
    


}
