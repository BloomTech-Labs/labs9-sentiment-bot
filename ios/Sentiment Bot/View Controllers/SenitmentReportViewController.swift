//
//  SenitmentReportViewController.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/21/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import Charts

class SenitmentReportViewController: UIViewController, ManagerProtocol {
    
    var user: User?
    
    var teamResponses: [Response]?
    
    var team: Team?
    
    var survey: Survey?
    
    var teamMembers: [User]?
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var emojiSelection: [String] = ["😐" ,"😃","😢","😑","😞", "😡", "😊"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let teamResponses = teamResponses else {
            NSLog("teamResponses wasn't set on SentimentReportViewController")
            return
        }
        createChart(teamResponses)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let themeInt = UserDefaults.standard.integer(forKey: "SelectedTheme")
        
        switch themeInt {
        case 0:
            view.backgroundColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            pieChart.holeColor =  UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        case 1:
            view.backgroundColor = UIColor.white
            pieChart.holeColor = UIColor.white
        default:
            NSLog("Theme not picked")
        }
        
    }
    
    @IBOutlet weak var userContainerView: UIView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        refreshChart()
    }
    
    
    func createChart(_ teamResponses: [Response]) {
        for emoji in emojiSelection {
            let filteredEmojis = teamResponses.filter({ $0.emoji == emoji})
            
            let chartDataEntry = PieChartDataEntry(value: Double((Double(filteredEmojis.count)/Double(teamResponses.count))*100.0))
            chartDataEntry.label = emoji
            
            sentimentEntries.append(chartDataEntry)
        }
        
        pieChart.chartDescription?.text = ""
        
        updateChartData()
    }
    
    func refreshChart() {
        sentimentEntries.removeAll()
        APIController.shared.getTeamResponses(teamId: (team?.id)!) { (responses, errorMessage) in
            DispatchQueue.main.async {
                self.teamResponses = responses
                self.createChart(self.teamResponses!)
            }
        }
    }
    
    var sentimentEntries: [PieChartDataEntry] = []

    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(values: sentimentEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        let colors = [UIColor.blue, UIColor.orange, UIColor.red, UIColor.lightGray, UIColor.green, UIColor.magenta, UIColor.purple]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
