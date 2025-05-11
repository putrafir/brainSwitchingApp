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

#Preview {
    ContentView()
}
