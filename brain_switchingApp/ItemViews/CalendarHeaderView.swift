//
//  CalendarHeaderView.swift
//  brain_switchingApp
//
//  Created by MacBook on 12/05/25.
//

import SwiftUI
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
                                    let calendar=Calendar.current
                                    if let fixedDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date){
                                        selectedDate = fixedDate
                                    }
                                   
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
        return days[(weekday + 5) % 7] 
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
