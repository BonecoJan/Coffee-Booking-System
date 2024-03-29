import SwiftUI
import SwiftUICharts


struct Statistics: View {
    
    @EnvironmentObject var transactionController: TransactionController
    @EnvironmentObject var shop: Shop
    @EnvironmentObject var viewState: ViewState
    
    struct DateValue: Identifiable {
        var id = UUID().uuidString
        var day: Int
        var date: Date
    }
    
    @State var currentDate: Date = Date()
    @State var  currentYear: Int = 0
    @State var  currentMonth: Int = 0
    @State var  currentWeek: Int = 0
    @State var  transactionType: String = ""
    @State var  legendTitle: String = ""
    @State var  disableTimeSelection: Bool = false
    
    
    enum ChartType {
        case weekly, monthly, yearly
    }
    @State private var chartType: ChartType = .weekly

    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(hex: 0xC08267))
    }
    
    //View for Statistics Selection
    var body: some View {
        VStack {
        HStack{
            VStack{
                Text("Statistics")
                    .bold()
            }
            Spacer()
            Button(action: {
                viewState.state = 4
            }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 25, height: 20, alignment: .leading)
            }).padding()
        }.padding()
        HStack(alignment: .center){
            Button(action: {
                self.currentDate = getCurrentWeek()
                chartType = .weekly
            }, label: {
                Text("Weekly")
                    .frame(width: 100, height: 30)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            .padding(.leading)
            .padding(.top)
            .padding(.bottom)
            Button(action: {
                self.currentDate = getCurrentMonth()
                chartType = .monthly
            }, label: {
                Text("Monthly")
                    .frame(width: 100, height: 30)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            .padding()
            Button(action: {
                self.currentDate = getCurrentYear()
                chartType = .yearly
            }, label: {
                Text("Yearly")
                    .frame(width: 100, height: 30)
                    .background(Color(hex: 0xD9D9D9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.black)
            })
            .padding(.top)
            .padding(.bottom)
            .padding(.trailing)
        }.isHidden(disableTimeSelection)
        TabView{

            VStack{
                switch chartType {
                case .weekly:
                    dateSelectionWeekly
                case .monthly:
                    dateSelectionMonthly
                case .yearly:
                    dateSelectionYeary
                }
            }
            .onAppear(perform: {
                self.transactionType = "amount"
                self.legendTitle = "Amount"
            })
            .tabItem{
                    Image(systemName: "cup.and.saucer")
                        .foregroundColor(.black)
                    Text("Coffees bought")
                        .foregroundColor(.black)
                }
            VStack{
                switch chartType {
                case .weekly:
                    dateSelectionWeekly
                case .monthly:
                    dateSelectionMonthly
                case .yearly:
                    dateSelectionYeary
                }
            }
            .onAppear(perform: {
                self.transactionType = "value"
                self.legendTitle = "Euros"
            })
            .tabItem{
                    Image(systemName: "eurosign.square")
                        .foregroundColor(.black)
                    Text("Money spent")
                        .foregroundColor(.black)
                }
            VStack {
                Text("Total items bought")
                    .padding()
                    .font(.headline)
                    .dynamicTypeSize(.xLarge)
                barChartItems
            }
            .background(Color(hex: 0xCCB9B1))
            .onAppear(perform: {
                self.disableTimeSelection = true
                self.legendTitle = "Amount"
            })
            .onDisappear(perform: {
                self.disableTimeSelection = false
            })
            .tabItem{
                    Image(systemName: "star.fill")
                        .foregroundColor(.black)
                    Text("Total Coffees")
                        .foregroundColor(.black)
                }
        }
        }
    }
    
    //View for weekly data
    var dateSelectionWeekly: some View {
        
        VStack(spacing: 20) {
            // Days
            let days = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
                        
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        currentWeek -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2 )
                }
                
                Button {
                    withAnimation {
                        currentWeek += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }

                
            }
            .padding(.horizontal)

            //Chart
            barChartWeek
            // Day View...
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                        Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }.rotationEffect(Angle(degrees: 70))
            }
            .frame(minWidth: 150, maxWidth: 900, alignment: .center)
            .padding()
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
            )
        .onChange(of: currentWeek) { newValue in
            // update week
            currentDate = getCurrentWeek()
        }
        .background(Color(hex: 0xCCB9B1))

    }
    
    //View for monthly data
    var dateSelectionMonthly: some View {
        
        VStack(spacing: 20) {
                                    
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2 )
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }

                
            }
            .padding(.horizontal)

            //Bar chart
            barChartMonth
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
            )
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth()
        }
        .background(Color(hex: 0xCCB9B1))

    }
    
    //View for yearly data
    var dateSelectionYeary: some View {
        
        
        VStack(spacing: 20) {
            
            let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                        
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        currentYear -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2 )
                }
                
                Button {
                    withAnimation {
                        currentYear += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }

                
            }
            .padding(.horizontal)
            barChartYear
            
            // Month View...
            HStack(spacing: 0) {
                ForEach(months, id: \.self) { day in
                    Text(String(day))
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .rotationEffect(Angle(degrees: 90))
            }
            .frame(minWidth: 150, maxWidth: 900, alignment: .center)
            .padding()
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
            )
        .onChange(of: currentYear) { newValue in
            // update year
            currentDate = getCurrentYear()
        }
        .background(Color(hex: 0xCCB9B1))

    }
    
    //view for total items bought
    var barChartItems: some View {

        VStack {
        
            let data = makeData(data: transactionController.dataBoughtItems(shop: shop))

            BarChart(chartData: data)
                .touchOverlay(chartData: data)
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .xAxisLabels(chartData: data)
                .yAxisLabels(chartData: data)
                .floatingInfoBox(chartData: data)
            .background(Color(hex: 0xCCB9B1))
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 175, maxHeight: 200, alignment: .center)
            .padding()
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .center
            )
        .background(Color(hex: 0xCCB9B1))

    }

    var barChartWeek: some View {
        
        VStack {
            let calendarDate = Calendar(identifier: .iso8601).dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: currentDate)
            let data = makeData(data: transactionController.dataForWeek(shop: shop, self.transactionType, calendarDate.year ?? 1970, calendarDate.weekOfYear ?? 1))
            
            BarChart(chartData: data)
                .touchOverlay(chartData: data)
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .yAxisLabels(chartData: data)
                .floatingInfoBox(chartData: data)
            .background(Color(hex: 0xCCB9B1))
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 175, maxHeight: 200, alignment: .center)
            .padding()
        }
    }
    
    
    var barChartMonth: some View {
        

        VStack {
        
            let calendarDate = Calendar(identifier: .iso8601).dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: currentDate)
            let data = makeData(data: transactionController.dataForMonth(shop: shop, self.transactionType, calendarDate.year ?? 1970, calendarDate.month ?? 1))
        
            BarChart(chartData: data)
                .touchOverlay(chartData: data)
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .yAxisLabels(chartData: data)
                .floatingInfoBox(chartData: data)
            .background(Color(hex: 0xCCB9B1))
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 175, maxHeight: 200, alignment: .center)
            .padding()
        }
    }
    
    var barChartYear: some View {
        

        VStack {
        
            let calendarDate = Calendar(identifier: .iso8601).dateComponents([.year, .month, .day, .weekday, .weekOfYear], from: currentDate)
            let data = makeData(data: transactionController.dataForYear(shop: shop, self.transactionType, calendarDate.year ?? 1970))

            BarChart(chartData: data)
                .touchOverlay(chartData: data)
                .xAxisGrid(chartData: data)
                .yAxisGrid(chartData: data)
                .yAxisLabels(chartData: data)
                .floatingInfoBox(chartData: data)
            .background(Color(hex: 0xCCB9B1))
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 175, maxHeight: 200, alignment: .center)
            .padding()
        }
    }
    
    func makeData(data: [BarChartDataPoint]) -> BarChartData {
                
        let data : BarDataSet = BarDataSet(dataPoints: data,
                                           legendTitle: self.legendTitle)
        
        let metadata = ChartMetadata(title: "Something", subtitle: "Some data")
        let xAxisLabels = [""]

        let chartStyle = BarChartStyle(infoBoxPlacement: .floating,
                                    xAxisGridStyle: GridStyle(numberOfLines: 3,
                                                              lineColour: Color(.lightGray).opacity(0.5),
                                                              lineWidth: 1),
                                    xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(90)),
                                    yAxisGridStyle: GridStyle(numberOfLines: 3,
                                                              lineColour: Color(.lightGray).opacity(0.5),
                                                              lineWidth: 1),
                                    yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 3)
        
        let barStyle = BarStyle(barWidth: 0.5, colour: ColourStyle(colour: .blue))
        

        return BarChartData(dataSets: data,
                         metadata: metadata,
                            xAxisLabels: xAxisLabels,
                            barStyle: barStyle,
                            chartStyle: chartStyle)
    }
    
    // Extraing elements for display
    func extraDate() -> [String] {
        
        let formatter = ISO8601DateFormatter()

        switch chartType {
        case .weekly:
            formatter.formatOptions = [
                .withYear,
                .withWeekOfYear,
                .withDashSeparatorInDate
            ]
            break
        case .monthly:
            formatter.formatOptions = [
                .withYear,
                .withMonth,
                .withDashSeparatorInDate
            ]
            break
        case .yearly:
            formatter.formatOptions = [
                .withYear,
                .withDashSeparatorInDate
            ]
            break
        }
        
        
        let date = formatter.string(from: currentDate)
         
        return date.components(separatedBy: "-")
    }
    
    func getCurrentYear() -> Date {
        let calendar = Calendar.current
        
        // Getting Current year date
        guard let currentYear = calendar.date(byAdding: .year, value: self.currentYear, to: Date()) else {
            return Date()
        }
        
        return currentYear
    }
    
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // Getting Current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func getCurrentWeek() -> Date {
        let calendar = Calendar.current
        
        // Getting Current week date
        guard let currentWeek = calendar.date(byAdding: .weekOfYear, value: self.currentWeek, to: Date()) else {
            return Date()
        }
        
        return currentWeek
    }
    
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        // Getting Current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            let dateValue =  DateValue(day: day, date: date)
            return dateValue
        }
        
        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}


struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Statistics()
    }
}

extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // geting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month, .weekOfYear, .weekday], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        
        // getting date...
        return range!.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
        }
        
    }
    
    
}
