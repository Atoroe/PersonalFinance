//
//  HomeViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 24.08.21.
//

import Charts

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillLayoutSubviews() {
        addGradient(for: view)
    }
    
}

//MARK: Init UI
extension HomeViewController {
    private func addGradient(for views: UIView...) {
        views.forEach { $0.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1)
        )
        }
    }
    
    private func setContanerViews(views: UIView...) {
        views.forEach { view in
            view.layer.borderWidth = 2
            view.layer.borderColor = CGColor.init(
                red: 195/255,
                green: 211/255,
                blue: 212/255,
                alpha: 1)
            view.layer.cornerRadius = 4
        }
    }
}

/*
//MARK: - pieChart
extension HomeViewController {
    private func pieChartUpdate () {
        let entry1 = PieChartDataEntry(value: Double(30), label: "#1")
        let entry2 = PieChartDataEntry(value: Double(50), label: "#2")
        let entry3 = PieChartDataEntry(value: Double(20), label: "#3")
        let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3], label: "Widget Types")
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        //pieChart.chartDescription?.text = "Share of Widgets by Type"

        //All other additions to this function will go here
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [UIColor.black]
        pieChart.backgroundColor = UIColor.black
        pieChart.holeColor = UIColor.clear
        pieChart.chartDescription?.textColor = UIColor.white
        pieChart.legend.textColor = UIColor.white
        
        pieChart.legend.font = UIFont(name: "Futura", size: 10)!
        pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!
        pieChart.chartDescription?.xOffset = pieChart.frame.width + 30
        pieChart.chartDescription?.yOffset = pieChart.frame.height * (2/3)
        pieChart.chartDescription?.textAlign = NSTextAlignment.left

        //This must stay at end of function
        pieChart.notifyDataSetChanged()
    }
}
 */

