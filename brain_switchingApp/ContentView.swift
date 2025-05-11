import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var currentMonthOffset = 0
    
    
    let tasks: [TaskItem] = [
        TaskItem(time: "08.00", title: "Task name", subtitle: "Study", color: .blue),
        TaskItem(time: "10.00", title: "Task name", subtitle: "Work", color: .red)
    ]

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeader(selectedDate: $selectedDate, currentMonthOffset: $currentMonthOffset)
                .padding(.vertical)

            Divider()

            ZStack{
                Color("Gray").ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Schedule")
                            .font(.title3)
                            .bold()
                            .padding(.top, 16)
                 
                        TaskCardView(time: "08.00", task: tasks[0])
                        
                       
                        TimeDelayView(from: "09.00", to: "09.30")
                        
                       
                        TaskCardView(time: "10.00", task: tasks[1])
                    }
                    .padding(.horizontal)
                }
            }
           

         

           
        }
    }
}

struct CalendarHeader: View {
    @Binding var selectedDate: Date
    @Binding var currentMonthOffset: Int

    var days: [String] { ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"] }

    var body: some View {
        let calendar = Calendar.current
        let displayedMonth = calendar.date(byAdding: .month, value: currentMonthOffset, to: Date()) ?? Date()
        let daysInMonth = generateDaysInMonth(for: displayedMonth)

        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    currentMonthOffset -= 1
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()

                Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.title3)
                    .bold()

              Spacer()

                Button(action: {
                    currentMonthOffset += 1
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(daysInMonth, id: \.self) { date in
                        VStack(spacing: 8) {
                            Text(dayName(for: date))
                                .font(.caption2)

                            Text("\(calendar.component(.day, from: date))")
                                .font(.body)
                                .fontWeight(.medium)
                                .frame(width: 32, height: 32)
                                .background(calendar.isDate(date, inSameDayAs: selectedDate) ? Color("Purple") : Color.clear)
                                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedDate = date
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }.padding(.top,20)

            Text("\(selectedDate.formatted(.dateTime.weekday(.wide).day().month().year()))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    func dayName(for date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        return days[(weekday + 5) % 7] // Adjust so Monday = "M"
    }

    func generateDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }

        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }
}

struct TaskItem {
    let time: String
    let title: String
    let subtitle: String
    let color: Color
}

struct TaskCardView: View {
    let time: String
    let task: TaskItem
    
    var body: some View {
        HStack(alignment: .top) {
            VStack{
                Text(time)
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(.gray)
                Spacer()
                Text(time)
                    .font(.subheadline)
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(.gray)

            }
           
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.subheadline)
                    .bold()
                HStack{
                    Text(task.subtitle)
                        .foregroundColor(task.color)
                   
                    Text("Detail")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
               
            }
            .padding()
            .background(Color(.white))
            .cornerRadius(12)
        }
    }
}

struct TimeDelayView: View {
    let from: String
    let to: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Time Delay")
                .font(.caption)
                .foregroundColor(Color("Purple"))
            VStack(alignment: .leading, spacing: 6) {
    
                HStack {
                    Circle()
                        .fill(Color("Purple"))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color("Purple"))
                        .frame(height: 1)
                    Text("\(from) - \(to)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Rectangle()
                        .fill(Color("Purple"))
                        .frame(height: 1)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
