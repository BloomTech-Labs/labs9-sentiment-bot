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
    
    @IBOutlet weak var userContainerView: UIView!
    @IBOutlet weak var pieChart: PieChartView!
    
//    var emojiSelection: [String] = ["😐" ,"😃","😢","😑","😞", "😡", "😊"]
    var emojiSelection: [String] = ["😃","😊","😐","😑","😢","😞","😡"]
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.refreshChart()
        }
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
        let legend = pieChart.legend
        
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
        
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        chartData.setValueFont(.systemFont(ofSize: 18, weight: .bold))
        chartData.setValueTextColor(.lightGray)
        
//        let darkRed = UIColor(red: 132.0/255.0, green: 13.0/255.0, blue: 27.0/255.0, alpha: 1.0)
//        let darkGreen = UIColor(red:0.00, green:0.39, blue:0.00, alpha:1.0)
//        let slateBlue = UIColor(red:0.28, green:0.24, blue:0.55, alpha:1.0)
//        let darkGolden = UIColor(red:0.72, green:0.53, blue:0.04, alpha:1.0)
//        let darkSlateGray = UIColor(red:0.18, green:0.31, blue:0.31, alpha:1.0)
//        let darkCyan = UIColor(red:0.00, green:0.55, blue:0.55, alpha:1.0)
//        let colors = [slateBlue, darkGolden, darkCyan, darkSlateGray, darkGreen, darkRed, UIColor.purple]
        
        let colors = [UIColor.happy7, UIColor.happy6, UIColor.happy5, UIColor.happy4, UIColor.happy3, UIColor.happy2, UIColor.red]
        
        chartDataSet.colors = colors //as! [NSUIColor]
        
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

extension UIColor {
    // Custom Colors for emojis - happy7 is happiest, happy1 is madest
    static let happy7 = UIColor(red: 59/255, green: 255/255, blue: 6/255, alpha: 1.0)
    static let happy6 = UIColor(red: 125/255, green: 255/255, blue: 67/255, alpha: 1.0)
    static let happy5 = UIColor(red: 195/255, green: 254/255, blue: 126/255, alpha: 1.0)
    static let happy4 = UIColor(red: 255/255, green: 242/255, blue: 44/255, alpha: 1.0)
    static let happy3 = UIColor(red: 254/255, green: 2184/255, blue: 6/255, alpha: 1.0)
    static let happy2 = UIColor(red: 255/255, green: 100/255, blue: 3/255, alpha: 1.0)
    static let happy1 = UIColor(red: 255/255, green: 100/255, blue: 3/255, alpha: 1.0)
    static let mainColorLight = UIColor(red: 68.0/255.0, green: 191.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    static let mainColorDark = UIColor(red:0.76, green:0.04, blue:0.05, alpha:1.0)
}
