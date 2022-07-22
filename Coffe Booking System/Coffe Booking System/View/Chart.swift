//
//  Chart.swift
//  Coffe Booking System
//
//  Created by Jan Wasilewitsch on 21.07.22.
//

import SwiftUI
import Charts

struct Chart: UIViewRepresentable {
    
    @EnvironmentObject var transactionVM: TransactionViewModel

    let entries: [BarChartDataEntry]
    //let entries: [ChartDataEntry]
    let barChart = BarChartView()
    @Binding var selectedYear: Int
    @Binding var selectedItem: String
    
    func makeUIView(context: Context) -> BarChartView {
        //return BarChartView()
        //lineChart.delegate = context.coordinator
        return barChart

    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        //let dataSet = BarChartDataSet(entries: entries)
        //uiView.data = BarChartData(dataSet: dataSet)
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = "Transactions"
        uiView.noDataText = "No Data"
        uiView.data = BarChartData(dataSet: dataSet)
        uiView.rightAxis.enabled = false
        if uiView.scaleX == 1.0 {
            uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
        }
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        //formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent:Chart
        init(parent: Chart) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: BarChartDataEntry, highlight: Highlight) {
            let month = TransactionViewModel.months[Int(entry.x)]
            let quantity = Double(entry.y)
            parent.selectedItem = "\(quantity) sold in \(month)"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func formatDataSet(dataSet: BarChartDataSet) {
        dataSet.colors = [.red]
        dataSet.valueColors = [.red]
//        dataSet.circleColors = [.black]
//        dataSet.circleHoleColor = .black
//        dataSet.circleRadius = 1.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = .red
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        leftAxis.valueFormatter =
            DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
        xAxis.valueFormatter = IndexAxisValueFormatter(values: TransactionViewModel.months)
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .red
    }
    func formatLegend(legend: Legend) {
        legend.textColor = .red
        legend.verticalAlignment = .top
        legend.horizontalAlignment = .right
        legend.drawInside = true
        legend.yOffset = 30.0
        
        
    }
    
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        VStack{
//            lineChartView
//        }
//    }
}

//struct Chart_Previews: PreviewProvider {
//    static var previews: some View {
//        Chart(entries: transactionVM.dataEntriesForYear("purchase", 2019, transactions: transactionVM.monthlySums), selectedYear: .constant(2019), selectedItem: .constant(""))
//    }
//}
